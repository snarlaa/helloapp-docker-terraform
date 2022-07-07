from flask import Flask
from flask import render_template
import socket
import random
import os
import argparse

app = Flask(__name__)

APP = os.environ.get('APP') or "localhost"

color_codes = {
    "angi": "#30336b",
    "404": "#3e169d",
}

images = {
    "angi": "https://bloximages.newyork1.vip.townnews.com/insideradio.com/content/tncms/assets/v3/editorial/f/ea/fea2bda0-a266-11eb-a1aa-a3925fd2c181/607fbfbfd0272.image.jpg",
    "404": "https://res.cloudinary.com/cloudusthad/image/upload/v1547053817/error_404.png",
}


@app.errorhandler(404)
def page_not_found(e):
    # note that we set the 404 status explicitly
    return render_template('hello.html', COLOR=color_codes[APP], IMAGE=images["404"]), 404


@app.route('/')
def main():
    return render_template('hello.html', COLOR=color_codes[APP], IMAGE=images[APP])


if __name__ == "__main__":

    # Run Flask Application
    app.run(host="0.0.0.0", port=8080)
