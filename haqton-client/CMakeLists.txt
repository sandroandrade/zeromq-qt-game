cmake_minimum_required(VERSION 3.14)

project(haqton LANGUAGES CXX)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

include(FeatureSummary)
include(ExternalProject)

# Handling ZeroMQ building
ExternalProject_Add(libzmq
    GIT_REPOSITORY https://github.com/zeromq/libzmq.git
    GIT_TAG v4.3.2
    PREFIX ${CMAKE_BINARY_DIR}/libzmq/
    CMAKE_ARGS
    -DBUILD_TESTS=OFF
    -DWITH_DOCS=OFF
    -DCMAKE_INSTALL_PREFIX=${CMAKE_BINARY_DIR}/libzmq-prefix
    -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE}
    -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
    -DCMAKE_FIND_ROOT_PATH=${CMAKE_FIND_ROOT_PATH}
    -DANDROID_PLATFORM=${ANDROID_PLATFORM}
    -DANDROID_ABI=${ANDROID_ABI}
    BUILD_BYPRODUCTS "libzmq-prefix/lib/${CMAKE_SHARED_LIBRARY_PREFIX}zmq${CMAKE_SHARED_LIBRARY_SUFFIX}"
    )
include_directories(${CMAKE_BINARY_DIR}/libzmq-prefix/include/)
add_library(zmq SHARED IMPORTED)
set_target_properties(zmq PROPERTIES
    IMPORTED_LOCATION
    "${CMAKE_BINARY_DIR}/libzmq-prefix/lib/${CMAKE_SHARED_LIBRARY_PREFIX}zmq${CMAKE_SHARED_LIBRARY_SUFFIX}"
    )

# Handling cppzmq building
ExternalProject_Add(cppzmq
    GIT_REPOSITORY https://github.com/zeromq/cppzmq.git
    GIT_TAG v4.6.0
    PREFIX ${CMAKE_BINARY_DIR}/cppzmq/
    CMAKE_ARGS
    -DCPPZMQ_BUILD_TESTS=OFF
    -DCMAKE_INSTALL_PREFIX=${CMAKE_BINARY_DIR}/cppzmq-prefix
    -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE}
    -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
    -DCMAKE_FIND_ROOT_PATH=${CMAKE_FIND_ROOT_PATH}
    -DANDROID_PLATFORM=${ANDROID_PLATFORM}
    -DANDROID_ABI=${ANDROID_ABI}
    -DCMAKE_PREFIX_PATH=${CMAKE_BINARY_DIR}/libzmq-prefix/
    -DCMAKE_FIND_ROOT_PATH_MODE_PACKAGE=BOTH
    )
add_dependencies(cppzmq libzmq)
include_directories(${CMAKE_BINARY_DIR}/cppzmq-prefix/include/)

# QtCreator supports the following variables for Android, which are identical to qmake Android variables.
# Check http://doc.qt.io/qt-5/deployment-android.html for more information.
# They need to be set before the find_package(Qt5 ...) call.

#if(ANDROID)
#    set(ANDROID_PACKAGE_SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/android")
#    if (ANDROID_ABI STREQUAL "armeabi-v7a")
#        set(ANDROID_EXTRA_LIBS
#            ${CMAKE_CURRENT_SOURCE_DIR}/path/to/libcrypto.so
#            ${CMAKE_CURRENT_SOURCE_DIR}/path/to/libssl.so)
#    endif()
#endif()

#TODO fix repetitive zeromq lib add

if(ANDROID)
    if (CMAKE_BUILD_TYPE EQUAL "DEBUG")
        set (SSL_ROOT_PATH ${CMAKE_CURRENT_SOURCE_DIR}/android_openssl/no-asm)
    else()
        set (SSL_ROOT_PATH ${CMAKE_CURRENT_SOURCE_DIR}/android_openssl)
    endif()

    if (ANDROID_ABI STREQUAL "armeabi-v7a")
        set(ANDROID_EXTRA_LIBS
            ${SSL_ROOT_PATH}/latest/arm/libcrypto_1_1.so
            ${SSL_ROOT_PATH}/latest/arm/libssl_1_1.so
            ${CMAKE_BINARY_DIR}/libzmq-prefix/lib/${CMAKE_SHARED_LIBRARY_PREFIX}zmq${CMAKE_SHARED_LIBRARY_SUFFIX}
            CACHE INTERNAL "")
    endif()

    if (ANDROID_ABI STREQUAL "arm64-v8a")
        set(ANDROID_EXTRA_LIBS
            ${SSL_ROOT_PATH}/latest/arm64/libcrypto_1_1.so
            ${SSL_ROOT_PATH}/latest/arm64/libssl_1_1.so
            ${CMAKE_BINARY_DIR}/libzmq-prefix/lib/${CMAKE_SHARED_LIBRARY_PREFIX}zmq${CMAKE_SHARED_LIBRARY_SUFFIX}
            CACHE INTERNAL "")
    endif()

    if (ANDROID_ABI STREQUAL "x86")
        set(ANDROID_EXTRA_LIBS
            ${SSL_ROOT_PATH}/latest/x86/libcrypto_1_1.so
            ${SSL_ROOT_PATH}/latest/x86/libssl_1_1.so
            ${CMAKE_BINARY_DIR}/libzmq-prefix/lib/${CMAKE_SHARED_LIBRARY_PREFIX}zmq${CMAKE_SHARED_LIBRARY_SUFFIX}
            CACHE INTERNAL "")
    endif()

    if (ANDROID_ABI STREQUAL "x86_64")
        set(ANDROID_EXTRA_LIBS
            ${SSL_ROOT_PATH}/latest/x86_64/libcrypto_1_1.so
            ${SSL_ROOT_PATH}/latest/x86_64/libssl_1_1.so
            ${CMAKE_BINARY_DIR}/libzmq-prefix/lib/${CMAKE_SHARED_LIBRARY_PREFIX}zmq${CMAKE_SHARED_LIBRARY_SUFFIX}
            CACHE INTERNAL "")
    endif()


endif()

find_package(QT NAMES Qt5 COMPONENTS Core Quick REQUIRED)
find_package(Qt5 COMPONENTS Core Quick REQUIRED)

set(HAQTON_SRC
    main.cpp
    core.cpp
    messagingcontroller.cpp
    zeromqsubscriberthread.cpp
    requestcontroller.cpp
    )

if(ANDROID)
    add_library(haqton SHARED
        ${HAQTON_SRC}
        qml.qrc
        )
else()
    add_executable(haqton
        ${HAQTON_SRC}
        qml.qrc
        )
endif()

target_compile_definitions(haqton
    PRIVATE $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>)
target_link_libraries(haqton PRIVATE
    Qt5::Core
    Qt5::Quick
    zmq
    )

add_dependencies(${PROJECT_NAME} libzmq cppzmq)

feature_summary(WHAT ALL FATAL_ON_MISSING_REQUIRED_PACKAGES)
