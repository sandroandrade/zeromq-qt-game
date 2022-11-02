#ifndef ZHELPERS_H
#define ZHELPERS_H

#include <zmq.hpp>

inline static zmq::send_result_t s_sendmore (zmq::socket_t & socket, const std::string & string) {
    zmq::message_t message(string.size());
    memcpy (message.data(), string.data(), string.size());

    auto result = socket.send (message, zmq::send_flags::sndmore);
    return result;
}

inline static zmq::send_result_t s_send (zmq::socket_t & socket, const std::string & string, zmq::send_flags flags = zmq::send_flags::none) {
    zmq::message_t message(string.size());
    memcpy (message.data(), string.data(), string.size());

    auto result = socket.send (message, flags);
    return result;
}

inline static std::string s_recv (zmq::socket_t & socket, zmq::recv_flags flags = zmq::recv_flags::none) {
    zmq::message_t message;
    socket.recv(message, flags);

    return std::string(static_cast<char*>(message.data()), message.size());
}

#endif // ZHELPERS_H

