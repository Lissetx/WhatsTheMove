import requests
import json
from bs4 import BeautifulSoup

print('Scraping Songkick...')


baseurl = 'https://www.songkick.com/metro-areas/13560-us-salt-lake-city?page={}#metro-area-calendar'
#url = 'https://www.songkick.com/metro-areas/13560-us-salt-lake-city'

# Send a GET request to the URL


page_number = 1
has_next_page = True

while has_next_page:

# Parse the HTML content of the page with BeautifulSoup
    url = baseurl.format(page_number)
    response = requests.get(url)
    soup = BeautifulSoup(response.content, 'html.parser')
    
# Find all the events on the page
    events = soup.find_all('li', {'class': 'event-listings-element'})

# Loop through each event and extract the desired data
    for event in events:
    # Get the date of the show
    
    # date is in the title attribute of the event listings element
   

        date = event.find('time')['datetime']
        
        

        
        # Get the event link
        event_link = event.find('a', {'class': 'event-link'})['href']
        
        # Follow the event link to get the ticket link
        event_response = requests.get("https://www.songkick.com/"+ event_link)
        event_soup = BeautifulSoup(event_response.content, 'html.parser')
        ticket_link_element = event_soup.find('a', {'class': 'buy-ticket-link'})
        #Get venue info
        venue = event_soup.find('p', {'class': 'venue-hcard'}).text
        print(venue)
        readable_date = event_soup.find('div', {'class': 'date-and-name'}).text
        print("title: " + readable_date)
        title = event_soup.find('h1', {'class': 'h0 summary'})
        location = event_soup.find('p', {'class': 'location'})
        
        
        artists = []
        
        artistsunordered = event_soup.find('ul', {'class': 'component expanded-lineup-details'})
        #for each li in the unordered list of artists
        if artistsunordered:
            for artist in artistsunordered:
                #within the class artist info there ids a main details class that has a tag with the artist name
                if artist:
                    artists.append(artist.find('div', {'class': 'main-details'}).find('a').text)
                    print(artists)
                    
        #artists.append(artistsunordered)
        print (artists)
        
        # headliners = event_soup.find('div', {'class': 'main-details'})
        # headliners = headliners.find('a').text
        # if headliners:
        #     artists.append(headliners)
        #     print(artists)
        
    
        # lineupnon = event_soup.find('li', {'class': 'non-headliner'})    
        # for artist in lineupnon:
        #     #within the class artist info there ids a main details class that has a tag with the artist name
        #     if artist:
        #         artists.append(artist.find('div', {'class': 'main-details'}).find('a').text)
        #         print(artists)
        
        ticket_link_element = event_soup.find('a', {'class': 'buy-ticket-link'})
        
        if ticket_link_element:
            ticket_link = ticket_link_element['href']
        else:
            ticket_link = None
        
        #create JSON object to send to database
        event = {
            "title": title,
            "readable_date": readable_date,
            "date": date,
            "artists": artists,
            "location": location,
            "ticket_link": ticket_link,
            "venue": venue,
        }
        
        #print the JSON object
         
        print("JSON: " + json.dumps(event))
         
        # Print the extracted data
        
        print('Title:', title)
        print('Date:', date)
        print('Venue:', venue)
        print('Artists:', artists)
        print('Readable Date:', readable_date)
        print('location:', location)
        print('Ticket Link:', ticket_link)