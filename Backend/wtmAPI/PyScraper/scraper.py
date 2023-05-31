import json
import time

import requests
from bs4 import BeautifulSoup
from fake_useragent import UserAgent
import pymongo

myconnection = pymongo.MongoClient("mongodb://localhost:5010/")
mydb = myconnection["WhatsTheMove"]
mycol = mydb["Concerts"]

ua = UserAgent()
st = time.time()

mycol.delete_many({})


print('Scraping Songkick...')

page_number = 1
baseurl = f'https://www.songkick.com/metro-areas/13560-us-salt-lake-city'
#url = 'https://www.songkick.com/metro-areas/13560-us-salt-lake-city'

# Send a GET request to the URL

headers ={
    "User-Agent": ua.random,
}

has_next_page = True

while has_next_page:

# Parse the HTML content of the page with BeautifulSoup
    url = f'{baseurl}/?page={page_number}#metro-area-calendar'
    response = requests.get(url, headers=headers)
    soup = BeautifulSoup(response.content, 'html.parser')
    
# Find all the events on the page
    events = soup.find_all('li', {'class': 'event-listings-element'})
    nav_div = soup.find('div', {'class': 'pagination'})
    pages = nav_div.find_all('a')
    last_page = pages[-2].text
    #change to int
    last_page = int(last_page)
    print("last page: " + str(last_page))

# Loop through each event and extract the desired data
    for event in events:
    # Get the date of the show
    
    # date is in the title attribute of the event listings element
   

        date = event.find('time')['datetime']
        print ("date:" + date)
        

        
        # Get the event link
        event_link = event.find('a', {'class': 'event-link'})['href']
        
        # Follow the event link to get the ticket link
        event_response = requests.get("https://www.songkick.com/"+ event_link)
        event_soup = BeautifulSoup(event_response.content, 'html.parser')
        ticket_link_element = event_soup.find('a', {'class': 'buy-ticket-link'})
        #Get venue info
        venue = event_soup.find('p', {'class': 'venue-hcard'})
        if venue is None:
            venue = "No venue info found"
        else:
            venue = venue.text
        print("venue:" + venue)
        readable_date = event_soup.find('div', {'class': 'date-and-name'})
        if readable_date is None:
            readable_date = ""
        else:
            readable_date = readable_date.text
        
        image_wrapper = event_soup.find('div', {'class': 'profile-picture-wrapper'})
        if image_wrapper is not None:
            image_link = image_wrapper.find('img')['src']
        else:
             image_wrapper = event_soup.find('div', {'class': 'profile-picture-wrap'})
             image_link = image_wrapper.find('img')['src']

        title = event_soup.find('h1', {'class': 'h0 summary'})
        #if no title is found find class h0 instead
        if title is None:
            title = event_soup.find('h1', {'class': 'h0'})
            if title is None:
                title = ""
            else:
                title = title.text + readable_date
            #i found locations work differently for some events, so i had to add this if its a festival
            venue_name = event_soup.find('p', {'class': 'first-location'})
            if venue_name is None:
                venue_name = "No venue found"
            else:
                venue_name = venue_name.text
            city_name = ""
        else: 
            title = title.text + readable_date
             #### This section i had diffculty getting the venue name and city name, i asked chatGPT multiple times for debugging purposes to complete this section ####
            location_div = event_soup.find('div', {'class': 'location'})
            venue_name = location_div.find('span', {'class': 'name'}).find('a')
            if venue_name is None:
                venue_name = "No venue found"
            else:
                venue_name = venue_name.text
                city_name = location_div.find_all('span')[1].find('a').text
            print("venue name: " + venue_name)
            print("city name: " + city_name)
        
        print("title: " + title)
        
       
        
        artists = []

# Find all <li> elements with class "headliner" or "non-headliner"
        headliner = event_soup.find('li', {'class': 'headliner'})
        
        if headliner:
            artist_name = headliner.find('div', {'class': 'main-details'}).find('span').find('a').text.strip()
            artists.append(artist_name)

        non_headliners = event_soup.find_all('li', {'class': 'non-headliner'})
        for artist in non_headliners:
            artist_name = artist.find('div', {'class': 'main-details'}).find('span').find('a').text.strip()
            artists.append(artist_name)

        if title == "" and artists != []:
            title = artists[0]
                  
        print(artists)
        
        ticket_link_element = event_soup.find('a', {'class': 'buy-ticket-link'})
        if ticket_link_element:
            ticket_link = 'https://www.songkick.com' + ticket_link_element['href']
        else:
            ticket_link = None
        #create JSON object to send to database
        eventJson = {
            "title": title, # found ???
            "readable_date": readable_date, #works
            "date": date, #works
            "artists": artists,# does not work
            "location": venue_name + ", " + city_name, #works
            "ticket_link": ticket_link,
            "venue": venue, #works
            "image_link": image_link
        }
        
        #print the JSON object
         
        print("JSON: " + json.dumps(eventJson))
        
        #send the JSON object to the database
        mycol.insert_one(eventJson)
         
        # Print the extracted data
        
        print('Title:', title)
        print('Date:', date)
        print('Venue:', venue)
        print('Artists:', artists)
        print('Readable Date:', readable_date)
        print('location:', venue_name + ", " + city_name)
        print('Ticket Link:', ticket_link)
        print('Image Link:', image_link)
    
    page_number += 1
    print("PAGE COUNT /////////////////////////////////////////////////////////////////////////////////////////" + str(page_number))
    if page_number > last_page:
        has_next_page = False
   
et = time.time()

# get the execution time
elapsed_time = et - st
print('Execution time:', elapsed_time, 'seconds')
    
## EXCUTION TIME 1303.352127313614 seconds
## minutes 21.7225362877269