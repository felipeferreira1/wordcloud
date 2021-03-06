#Script para montar wordcloud relat�rios bcb
#Adaptado por: Felipe Simpl�cio Ferreira
#�ltima atualiza��o: 05/11/2020

#Definindo diret�rios a serem utilizados
getwd()
setwd("C:\\Users\\User\\Documents")

#Carregando pacotes que ser�o utilizados
library(tm) #Para manipular o objeto de texto
library(wordcloud) #Gerador do word-cloud
library(RColorBrewer) #Paletas de cores
library(readtext) #Para ler o arquivo pdf
library(tidyverse) #Para filtrar arquivos
library(data.table) #Para manipula��o dos arquivos

#Lendo o arquivo pdf da internet
url <- "https://www.bcb.gov.br/content/copom/atascopom/Copom234-not20201028234.pdf" #Url relat�rio copom
base_palavras <- readtext(url) #Lendo url
corpo_palavras <- Corpus(VectorSource(base_palavras)) #Transformando em corpo_palavrasus
corpo_palavras <- tm_map(corpo_palavras, PlainTextDocument) #Transformar em "texto plano"
corpo_palavras <- tm_map(corpo_palavras, removePunctuation, language = "pt") #Remover a pontua��o 
corpo_palavras <- tm_map(corpo_palavras, removeNumbers) #Remover os n�meros
corpo_palavras <- tm_map(corpo_palavras, tolower) #Deixar todas as letras minusculas
corpo_palavras <- tm_map(corpo_palavras, stripWhitespace) #Tirar os espa�os em branco
corpo_palavras <- tm_map(corpo_palavras, removeWords, stopwords(kind = "pt")) #Remover conectivos
#corpo_palavras <- tm_map(corpo_palavras, stemDocument, language = "pt") #Junta palavras parecidas (t� comendo um peda�o das palavras)
#corpo_palavras <- tm_map(corpo_palavras, removeWords, c("")) #Remover palavras espec�ficas

#Criando paleta de cores
color <- brewer.pal(32,"Spectral") #Paleta de cor

#Aplicando paleta de cores
#wordcloud(corpo_palavras, max.words = 100, min.freq=5, random.order = FALSE, colors = color) #Mostrar wordcloud colorida, com palavras com mais de 5 repeti��es
#wordcloud(corpo_palavras, max.words = 100, random.order = FALSE, colors = color, scale=c(8, .3)) #Ajustando tamanho das palavras

#Criando matriz auxiliar
matrix_aux <- TermDocumentMatrix(corpo_palavras)
matrix_aux <- as.matrix(matrix_aux)
matrix_aux <- sort(rowSums(matrix_aux),decreasing=TRUE)
matrix_aux <- data.table(word = names(matrix_aux),freq=matrix_aux, row.names = NULL)

#matrix_aux <- filter(matrix_aux2, freq > 15) #Filtrando para ver s� as palavras que v�o pro wordcloud
matrix_aux <- matrix_aux[-c(1,3,4,27,136),] #Tirando valores estranhos

#Agora sim!
#png(file="wordplot.png")
#layout(matrix(c(1, 2), nrow=2), heights=c(1, 4))
#par(mar=rep(0, 4))
#plot.new()
#text(x=0.5, y=0.5, "234� ata da reuni�o do Copom")
dev.new(width=15, height=10, unit="cm")
wordcloud(matrix_aux$word,matrix_aux$freq,
          random.order=FALSE, rot.per=0.35, 
          use.r.layout=FALSE, colors=color)
text(x=0.5, y=1, "234� ata da reuni�o do Copom")
#dev.off()

#Para Compara��o
url2 <- "https://www.bcb.gov.br/content/copom/atascopom/Copom233-not20200916233.pdf"
base_palavras2 <- readtext(url2) #Lendo url
corpo_palavras2 <- Corpus(VectorSource(base_palavras2)) #Transformando em corpo_palavras2us
corpo_palavras2 <- tm_map(corpo_palavras2, PlainTextDocument) #Transformar em "texto plano"
corpo_palavras2 <- tm_map(corpo_palavras2, removePunctuation, language = "pt") #Remover a pontua��o 
corpo_palavras2 <- tm_map(corpo_palavras2, removeNumbers) #Remover os n�meros
corpo_palavras2 <- tm_map(corpo_palavras2, tolower) #Deixar todas as letras minusculas
corpo_palavras2 <- tm_map(corpo_palavras2, stripWhitespace) #Tirar os espa�os em branco
corpo_palavras2 <- tm_map(corpo_palavras2, removeWords, stopwords(kind = "pt")) #Remover conectivos

matrix_aux2 <- TermDocumentMatrix(corpo_palavras2)
matrix_aux2 <- as.matrix(matrix_aux2)
matrix_aux2 <- sort(rowSums(matrix_aux2),decreasing=TRUE)
matrix_aux2 <- data.table(word = names(matrix_aux2),freq=matrix_aux2, row.names = NULL)

#matrix_aux2 <- filter(matrix_aux2, freq > 15) #Filtrando para ver s� as palavras que v�o pro wordcloud
matrix_aux2 <- matrix_aux2[-c(7),] #Tirando valores estranhos

#Combinando matrizes
matrix_combinada <- merge(matrix_aux, matrix_aux2, by = "word", all = T)
matrix_combinada <- as.matrix(matrix_combinada, rownames = T)
colnames(matrix_combinada) <- c("234�","233�")
matrix_combinada <- matrix_combinada[complete.cases(matrix_combinada),]

#matrix_combinada <- matrix_combinada[-c(),] #Tirando valores estranhos

dev.new(width=5, height=4, unit="cm")
comparison.cloud(matrix_combinada, random.order=FALSE, use.r.layout=FALSE, title.size = 2, match.colors = T, max.words=150)
text(x=0.5, y=1, "Compara��o de atas da reuni�o do Copom")
