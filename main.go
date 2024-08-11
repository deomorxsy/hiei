package main

import (
    "log"
    "net/http"
    "os"
    "os/signal"
    "syscall"
    "github.com/prometheus/client_golang/prometheus/promhttp"

)

func cleanup(){}

func main() {
    signals := make(chan os.Signal, 1)
    signal.Notify(
        signals,
        syscall.SIGINT,
        syscall.SIGTERM,
        syscall.SIGQUIT,
    )

    go func(){
        switch <-signals {
            case syscall.SIGINT, syscall.SIGTERM:
                cleanup()
                os.Exit(1)
            case syscall.SIGQUIT:
                cleanup()
                panic("SIGQUIT called")
        }
    }()

    http.Handle("/metrics", promhttp.Handler())
    http.ListenAndServe(":2112", nil)

    http.HandleFunc("/rolldice", rolldice)
    log.Fatal(http.ListenAndServe(":8080", nil))

}
