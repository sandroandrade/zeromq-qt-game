# Building and starting RESTful server

$ cd haqton-server
$ docker build -t haqton-server ./

Start the container:

$ docker run -d -p 4001:4001 --network="host" --name haqton-server haqton-server

Add some database data:

$ docker exec -it haqton-server sh
$ apk add sqlite
$ sqlite3 db/development.sqlite3

insert into questions values (1, "What the best no-code game development platform?", 0);
insert into question_options values (1, "Game Unleashed", 1);
insert into question_options values (2, "Buildbox", 1);
insert into question_options values (3, "Popcorn!", 1);

insert into questions values (2, "What the best UI development toolkit?", 0);
insert into question_options values (4, "Qt", 2);
insert into question_options values (5, "WxWidgets", 2);
insert into question_options values (6, "GTK", 2);

# Building and starting ZeroMQ distributed pub-sub:

$ cd zeromq
$ g++ -o rrbroker rrbroker.cpp -lzmq
$ ./rrbroker &

# Building and running Qt client:

$ cd haqton-client
$ mkdir build && cd build
$ cmake -GNinja .. (optionally, set CMAKE_PREFIX_PATH to your Qt 5.15 installation dir)
$ ninja
$ ./haqton &
$ ./haqton &

Enjoy!
