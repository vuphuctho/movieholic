from imdb import IMDb
from collections import Counter
import urllib2
import urllib
import json
import requests

i = IMDb('http')
titles = open('titles.txt','r')
sorted_keywords_file = open('sorted_keywords.txt','w')

to_write = ''
for line in titles:

	summary=''
	(title,url) = line.split('||')
	url=url.rstrip('\n')
	
	print title	
	
	to_write += '(movie (movieName \"'+title+'\"))\n'
	
	response = urllib2.urlopen("http://www.themoviespoiler.com/"+url)
	response_summary = response.read()
	
	file_content = open('site_content.txt','w')
	file_content.write(response_summary)
	file_content.close()

	file_content = open('site_content.txt','r')	
	count=0
	
	for line in file_content:				
		if line.find('<p>')!=-1 and line.find('<p><')==-1:	
			line = line.replace('<p>','').replace('</p>','').replace('&quot;','').replace('&nbsp;','').replace('&amp;','').replace('&rsquo;','').replace('&ldquo;','').replace('&rdquo;','')
			summary += line			
			
	file_content.close()
	file_content = open('site_content.txt','w')
	file_content.write(summary)
	file_content.close()	

	parameters = {'t':title}	
	response_keywords = requests.get("http://www.omdbapi.com/?", params=parameters)
	movie_id = response_keywords.json()['imdbID']
	movie_data = i.get_movie(movie_id[2:], info='keywords')	
	
	counter = Counter()
	for key in movie_data['keywords']:
		if summary.count(key)>0:
			counter[key] = summary.count(key)

	for (key,value) in counter.most_common(10):		
		to_write +='(keyword (word \"'+str(key)+'\") (movieName \"'+title+'\") (number '+str(value)+'))\n'
	to_write += '\n'	
	
sorted_keywords_file.write(to_write)
