add_executable(mlir-edsc-builder-api-test
  builder-api-test.cpp
)

llvm_update_compile_flags(mlir-edsc-builder-api-test)

target_link_libraries(mlir-edsc-builder-api-test
  MLIRAffineOps
  MLIRIR
  MLIREDSC
  MLIRStandardOps
  MLIRTransforms
  LLVMCore
  LLVMSupport
)

whole_archive_link(mlir-edsc-builder-api-test
  MLIRAffineOps
  MLIRStandardOps
  MLIRTransforms
)
