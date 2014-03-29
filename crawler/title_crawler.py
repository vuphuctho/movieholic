from bs4 import BeautifulSoup
import urllib2


file_content = open('index_page.txt','r')


contents = ""
for line in file_content:
	contents += line + '\n'

file_content.close()	

soup = BeautifulSoup(contents)

table = soup.find('table', {'class': 'movietitles'})

rows = table.findAll('tr')

file_content = open('titles.txt','w')

for tr in rows:
    cols = tr.findAll('td')    
    
    for col in cols:
    	link = col.find('a')
    	if link is not None:
	    	url = link.get('href')
	    	title = link.getText()
	        file_content.write(title + "||" + url + '\n')
file_content.close()	        
