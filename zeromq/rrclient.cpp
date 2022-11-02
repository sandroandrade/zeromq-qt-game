#include <thread>
#include "zhelpers.h"

int main (int argc, char *argv[])
{
    zmq::context_t context(1);

    zmq::socket_t requester(context, ZMQ_PUB);
    requester.connect("tcp://localhost:5559");

    while(1) {
        s_sendmore (requester, std::string("003"));
        s_send (requester, std::string("Hello"));
        std::this_thread::sleep_for(std::chrono::seconds(1));
    }
}
