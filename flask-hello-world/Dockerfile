FROM --platform=linux/amd64 python:3.7-alpine
 
# Create app directory
WORKDIR /app
 
# Install app dependencies
COPY requirements.txt ./
 
RUN pip3 install -r requirements.txt
 
# Bundle app source
COPY . .
 
EXPOSE 5000

CMD ["python3", "-m", "flask", "run", "--host=0.0.0.0"]
