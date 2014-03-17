movieholic
==========

Introduction
============
An application for movie searching. User can type in any event happening in the movie. The application will search in the database and retrieve the movie whose content is closest to the hint given.

Source of movie's content: http://www.themoviespoiler.com/

The system is built on CLIPS Expert System Language.

How to run:
===========
You must have CLIPS to run the program. The software can be downloaded here: http://clipsrules.sourceforge.net/
Clone the repository to your local machine.
In CLIPS console, call the file main.bat by typing: (batch "your_directory/main.bat")
For example: if the file main.bat is inside folder repo/movieholic then call: (batch "repo/movieholic/main.bat")

Process of searching:
=====================
1. Query processing: save event as string
2. Pattern matching: match keywords appearing in movie's content with words in event given by user.
3. Similarity measuring: currently, we intend to use cosine similarity formula to compute
4. Retrieving results: collect top results based on similarity
5. Further processing: the application will narrow down the results further using top-down techniques

Current status:
===============
1. Finished
2. Finished
3. Unfinished. Using simple formula (addition). Will implement cosine similarity formula later on.
4. Finished.
5. Unfinished. Currently stop at first query.