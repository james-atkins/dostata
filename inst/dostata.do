global DOSTATA_RUN : env DOSTATA_RUN
global DOSTATA_INPUT : env DOSTATA_INPUT

while fileexists("$DOSTATA_RUN") {
    while (fileexists("$DOSTATA_RUN") & !fileexists("$DOSTATA_INPUT")) {
        sleep 100
    }

    if fileexists("$DOSTATA_INPUT") {
        do "$DOSTATA_INPUT"
    }
}
