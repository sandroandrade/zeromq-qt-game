#include <thread>
#include <iostream>
#include "zhelpers.h"

int main (int argc, char *argv[])
{
    zmq::context_t context(1);

    //  Socket facing clients
    zmq::socket_t frontend (context, ZMQ_XSUB);
    frontend.bind("tcp://*:5559");

    //  Socket facing services
    zmq::socket_t backend (context, ZMQ_XPUB);
    backend.bind("tcp://*:5560");

    std::cout << "Iniciando o proxy" << std::endl;
    zmq::proxy(frontend, backend);
    return 0;
}
