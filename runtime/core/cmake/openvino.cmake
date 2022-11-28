if(OPENVINO)
  FetchContent_Declare(openvino
    URL https://storage.openvinotoolkit.org/repositories/openvino/packages/2022.1/l_openvino_toolkit_runtime_rhel8_p_2022.1.0.643.tgz
  )

  FetchContent_MakeAvailable(openvino)
  # include_directories("${openvino_SOURCE_DIR}/runtime/include/ie")
  # include_directories("${openvino_SOURCE_DIR}/runtime/include")
  # link_directories("${openvino_SOURCE_DIR}/runtime/lib/intel64")
  add_definitions(-DUSE_OPENVINO)
endif()
