import requests
#Successfully created data for my news app and it is totally working. :)

import json
from bs4 import BeautifulSoup as bs

pagex = "https://newsapi.org/sources"
page = requests.get(pagex)
soup = bs(page.text,'html.parser')
l={}
k=[]
index=0
url_list = []
x = [l.a["title"] for l in soup.findAll(class_="source publisher fl-ns w-25-l w-50-m mb2")]
y = [l.a.img["data-src"] for l in soup.findAll(class_="source publisher fl-ns w-25-l w-50-m mb2")]
for i in range(len(x)):
    l["title"] = x[i]
#y = [l.a.img["data-src"] for l in soup.findAll(class_="source publisher fl-ns w-25-l w-50-m mb2")]
    l["logo"] = y[i]
    k.append(l)
    l={}
#print(k)
#print("\n\n")
#print(len(y))
x = [l.a["href"] for l in soup.findAll(class_="source publisher fl-ns w-25-l w-50-m mb2")]
for i in x:
    url = "https://newsapi.org" + i
    page = requests.get(url)
    soup = bs(page.text,'html.parser')
    x = [l.text for l in soup.findAll("span",{"class":"http-url"})]
    #print(x[0])
    z = ''.join(list(x[0])[:-7])+'08394049a09c45e2ac6253eadd754082'
    url_list.append(z)
    #print(url_list)
#print("\n\n\n")
for i in range(len(y)):
    k[i]["url"] = url_list[i]
    #print(k[i])
    #index+=1
k = json.dumps(k)
print(k)
#https://api.myjson.com/bins/1902n2
#This is where the output is stored.
