# Covid-19 

#### Project Motivation
* There are thousands of research papers written on Covid-19. To find a vaccine the doctors, scientists must go through every research paper to find relevant articles.
* The solution to this problem is to create groups or cluster relevant articles together.
* Hence, my motivation behind this project was to help the community by clustering relevant articles together to help find a vaccine on Covid-19.


#### Goal of this project:
* To cluster different research papers together under one section.
* Apply NLP techniques to process the text information based on title, abstract and summary.
* Create clusters by using K-Means algorithm


## The steps taken in the Project


#### Data Preprocessing 

* Splitting the words form abstract and body text

<p align="center">
  <img width="650" height="200" src="Plots/stripping_words.png">
</p>


* Eliminating duplicates

<p align="center">
  <img width="500" height="150" src="Plots/duplicate_values.png">
</p>


* Eliminating null values

<p align="center">
  <img width="400" height="400" src="Plots/null_values.png">
</p>



* Plotting Unique word count 

<p align="center">
  <img width="400" height="250" src="Plots/unique_word_count.png">
</p>


* Landetect package to identify different languages

<p align="center">
  <img width="400" height="400" src="Plots/lang_detect.png">
</p>


* Plotting different languages

<p align="center">
  <img width="400" height="250" src="Plots/Lang_distribution.png">
</p>



* Converting raw document to matrix of tf-idf features

<p align="center">
  <img width="400" height="300" src="Plots/tf-idf.png">
</p>


* Reducing the dimensions of vectorised data using PCA

<p align="center">
  <img width="400" height="200" src="Plots/pca.png">
</p>


* Plotting distortions using Elbow Method to find the optimal K value

<p align="center">
  <img width="400" height="300" src="Plots/optimal_kvalue.png">
</p>


* Using K-means clustering, plotting the data

<p align="center">
  <img width="800" height="800" src="Plots/cluster_tsne.png">
</p>
