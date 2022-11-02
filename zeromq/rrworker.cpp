#include <iostream>
#include "zhelpers.h"

int main (int argc, char *argv[])
{
    zmq::context_t context(1);

    zmq::socket_t responder(context, ZMQ_SUB);
    responder.connect("tcp://localhost:5560");
    
    std::stringstream ss;
    ss << std::dec << std::setw(3) << std::setfill('0') << 3;

    responder.setsockopt(ZMQ_SUBSCRIBE, ss.str().c_str(), ss.str().size());

    while(1)
    {
        //  Wait for next request from client
        std::string topic = s_recv (responder);
        std::string string = s_recv (responder);
        
        std::cout << "Received request: " << string << " from topic " << topic << std::endl;
    }
}
