from imdb import IMDb
from collections import Counter
import urllib2
import urllib
import json
import requests

i = IMDb('http')
titles = open('titles.txt','r')
sorted_keywords_file = open('sorted_keywords.txt','a')
wrong_files = open('wrong_files.txt','a')

for line in titles:

	to_write = ''
	summary=''
	(title,url) = line.split('||')
	url=url.rstrip('\n')	

	parameters = {'t':title}	
	response_keywords = requests.get("http://www.omdbapi.com/?", params=parameters)
	
	if 'imdbID' not in response_keywords.json():
		wrong_files.write(title + '//Wrong title'+'\n')
		continue

	movie_id = response_keywords.json()['imdbID']	
	movie_data = i.get_movie(movie_id[2:], info='keywords')	
	
	if movie_data.get('keywords',None) is None:
		wrong_files.write(title + '//Keywords not exist'+'\n')
		continue

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
	
	counter = Counter()
	for key in movie_data['keywords']:
		if summary.count(key)>0:
			counter[key] = summary.count(key)

	title_keys = title.split(' ')
	for key in title_keys:
		key = key.lower()
		counter[key]=10

	for (key,value) in counter.most_common(20):		
		to_write +='(keyword (word \"'+str(key)+'\") (movieName \"'+title+'\") (number '+str(value)+'))\n'
	to_write += '\n'	
	sorted_keywords_file.write(to_write)
	
#sorted_keywords_file.write(to_write)
