cmake_minimum_required(VERSION 3.16)

project(Enigmorph VERSION 2.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

find_package(Qt6 REQUIRED COMPONENTS Core Quick Gui QuickControls2)

add_executable(Enigmorph
    main.cpp
    enigmorph.h
    enigmorph.cpp
    resources.qrc
    logo.rc
)

target_link_libraries(Enigmorph
    PRIVATE 
    Qt6::Core 
    Qt6::Quick 
    Qt6::Gui
    Qt6::QuickControls2
)

if(WIN32)
    set_target_properties(Enigmorph PROPERTIES
        WIN32_EXECUTABLE TRUE
    )
endif()

install(TARGETS Enigmorph
    BUNDLE DESTINATION .
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)