package main

import (
	"log"
	"math"
	"net/http"
)

func handler(w http.ResponseWriter, r *http.Request) {
	x := 0.001
	for i := 0; i <= 100000; i++ {
		x += math.Sqrt(x)
	}
	w.Write([]byte("Kapcsolat!"))
}

func main() {
	http.HandleFunc("/", handler)
	log.Fatal(http.ListenAndServe(":5001", nil))
}
