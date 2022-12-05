if(OPENVINO)
  include(gflags)
  set(VINO_VERSION "2022.2.0")

  if(${CMAKE_SYSTEM_NAME} STREQUAL "Windows")
    set(VINO_URL "https://storage.openvinotoolkit.org/repositories/openvino/packages/2022.2/windows/w_openvino_toolkit_windows_${VINO_VERSION}.7713.af16ea1d79a_x86_64.zip")
    set(URL_HASH "SHA256=450979453f254c630b459106d9682625be48a05a354760dfb86f993a9945a256")
  elseif(${CMAKE_SYSTEM_NAME} STREQUAL "Linux")
    # todo
    set(VINO_URL "https://storage.openvinotoolkit.org/repositories/openvino/packages/2022.2/linux/l_openvino_toolkit_rhel8_${VINO_VERSION}.7713.af16ea1d79a_x86_64.tgz")

  # set(URL_HASH "SHA256=5820d9f343df73c63b6b2b174a1ff62575032e171c9564bcf92060f46827d0ac")
  elseif(${CMAKE_SYSTEM_NAME} STREQUAL "Darwin")
    set(VINO_URL "https://storage.openvinotoolkit.org/repositories/openvino/packages/2022.2/macos/m_openvino_toolkit_osx_${VINO_VERSION}.7713.af16ea1d79a_x86_64.tgz")
    set(URL_HASH "SHA256=445107564a39cec77d5ab94b6eaecaf43c9d536eb7f0bd513d1b1ffb5facca8b")
  else()
    message(FATAL_ERROR "Unsupported CMake System Name '${CMAKE_SYSTEM_NAME}' (expected 'Windows', 'Linux' or 'Darwin')")
  endif()

  if(${CMAKE_SYSTEM_NAME} STREQUAL "Linux")
    set(ENABLE_INTEL_GPU OFF CACHE BOOL "Build OV with GPU" FORCE)
    set(ENABLE_INTEL_MYRIAD OFF CACHE BOOL "Build OV with MYRIAD" FORCE)
    set(ENABLE_INTEL_GNA OFF CACHE BOOL "Build OV with GNA" FORCE)
    set(ENABLE_INTEL_CPU ON CACHE BOOL "Build OV with CPU" FORCE)
    set(BUILD_SHARED_LIBS ON CACHE BOOL "Build OV in shared library" FORCE)
    set(ENABLE_SAMPLES OFF CACHE BOOL "Build OV with Example" FORCE)
    set(ENABLE_TESTS OFF CACHE BOOL "Build OV with Tests" FORCE)
    set(ENABLE_COMPILE_TOOL OFF CACHE BOOL "Build OV with COMPILE_TOOL" FORCE)
    FetchContent_Declare(openvino
      GIT_REPOSITORY https://github.com/openvinotoolkit/openvino.git
      GIT_TAG 3eac2cd613306108842d9d38a27435debccb9206) # master in 2/12/2022
    FetchContent_MakeAvailable(openvino)
    # add_dependencies(openvino gflags)
    # target_link_libraries(openvino PUBLIC gflags_nothreads_static)
  else()
    FetchContent_Declare(openvino
      URL ${VINO_URL}
      URL_HASH ${URL_HASH}
    )
    FetchContent_MakeAvailable(openvino)
    include_directories(${openvino_SOURCE_DIR}/include)
    link_directories(${openvino_SOURCE_DIR}/lib)
  endif()

  if(MSVC)
    file(GLOB ONNX_DLLS "${openvino_SOURCE_DIR}/lib/*.dll")
    file(COPY ${VINO_DLLS} DESTINATION ${CMAKE_BINARY_DIR}/bin/${CMAKE_BUILD_TYPE})
  endif()

  add_definitions(-DUSE_OPENVINO)
endif()
