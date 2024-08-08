package main

import (
    "log"
    "net/http"

    "github.com/prometheus/client_golang/prometheus/promhttp"

)

func main() {
    http.Handle("/metrics", promhttp.Handler())
    http.ListenAndServe(":2112", nil)

    http.HandleFunc("/rolldice", rolldice)
    log.Fatal(http.ListenAndServe(":8080", nil))

}
