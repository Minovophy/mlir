// RUN: mlir-opt %s -verify | mlir-opt -verify | FileCheck %s

func @range(%arg0: index, %arg1: index, %arg2: index) {
  %0 = linalg.range %arg0:%arg1:%arg2 : !linalg.range
  return
}
// CHECK-LABEL: func @range(%arg0: index, %arg1: index, %arg2: index) {
//  CHECK-NEXT:  %0 = linalg.range %arg0:%arg1:%arg2 : !linalg.range

func @buffer(%arg0: index, %arg1: index) {
  %0 = muli %arg0, %arg0 : index
  %1 = linalg.buffer_alloc %0 : !linalg.buffer<f32>
  linalg.buffer_dealloc %1 : !linalg.buffer<f32>
  return
}
// CHECK-LABEL: func @buffer(%arg0: index, %arg1: index) {
//  CHECK-NEXT:  %0 = muli %arg0, %arg0 : index
//  CHECK-NEXT:  %1 = linalg.buffer_alloc %0 : !linalg.buffer<f32>
//  CHECK-NEXT:  linalg.buffer_dealloc %1 : !linalg.buffer<f32>

func @views(%arg0: index, %arg1: index, %arg2: index, %arg3: index, %arg4: index) {
  %0 = muli %arg0, %arg0 : index
  %1 = linalg.buffer_alloc %0 : !linalg.buffer<f32>
  %2 = linalg.range %arg2:%arg3:%arg4 : !linalg.range
  %3 = linalg.view %1[%2, %2] : !linalg.view<?x?xf32>
  %4 = linalg.slice %3[%2, %2] : !linalg.view<?x?xf32>, !linalg.range, !linalg.range, !linalg.view<?x?xf32>
  %5 = linalg.slice %3[%2, %arg2] : !linalg.view<?x?xf32>, !linalg.range, index, !linalg.view<?xf32>
  %6 = linalg.slice %3[%arg2, %2] : !linalg.view<?x?xf32>, index, !linalg.range, !linalg.view<?xf32>
  %7 = linalg.slice %3[%arg2, %arg3] : !linalg.view<?x?xf32>, index, index, !linalg.view<f32>
  linalg.buffer_dealloc %1 : !linalg.buffer<f32>
  return
}
// CHECK-LABEL: func @views(%arg0: index, %arg1: index, %arg2: index, %arg3: index, %arg4: index) {
//  CHECK-NEXT:  %0 = muli %arg0, %arg0 : index
//  CHECK-NEXT:  %1 = linalg.buffer_alloc %0 : !linalg.buffer<f32>
//  CHECK-NEXT:  %2 = linalg.range %arg2:%arg3:%arg4 : !linalg.range
//  CHECK-NEXT:  %3 = linalg.view %1[%2, %2] : !linalg.view<?x?xf32>
//  CHECK-NEXT:  %4 = linalg.slice %3[%2, %2] : !linalg.view<?x?xf32>, !linalg.range, !linalg.range, !linalg.view<?x?xf32>
//  CHECK-NEXT:  %5 = linalg.slice %3[%2, %arg2] : !linalg.view<?x?xf32>, !linalg.range, index, !linalg.view<?xf32>
//  CHECK-NEXT:  %6 = linalg.slice %3[%arg2, %2] : !linalg.view<?x?xf32>, index, !linalg.range, !linalg.view<?xf32>
//  CHECK-NEXT:  %7 = linalg.slice %3[%arg2, %arg3] : !linalg.view<?x?xf32>, index, index, !linalg.view<f32>
//  CHECK-NEXT:  linalg.buffer_dealloc %1 : !linalg.buffer<f32>

func @ops(%arg0: !linalg.view<?x?xf32>, %arg1: !linalg.view<?xf32>, %arg2: !linalg.view<?xf32>, %arg3: !linalg.view<f32>) {
  linalg.matmul(%arg0, %arg0, %arg0) : !linalg.view<?x?xf32>, !linalg.view<?x?xf32>, !linalg.view<?x?xf32>
  linalg.matvec(%arg0, %arg1, %arg2) : !linalg.view<?x?xf32>, !linalg.view<?xf32>, !linalg.view<?xf32>
  linalg.dot(%arg1, %arg2, %arg3) : !linalg.view<?xf32>, !linalg.view<?xf32>, !linalg.view<f32>
  return
}
// CHECK-LABEL: func @ops(%arg0: !linalg.view<?x?xf32>, %arg1: !linalg.view<?xf32>, %arg2: !linalg.view<?xf32>, %arg3: !linalg.view<f32>) {
//  CHECK-NEXT:  linalg.matmul(%arg0, %arg0, %arg0) : !linalg.view<?x?xf32>, !linalg.view<?x?xf32>, !linalg.view<?x?xf32>
//  CHECK-NEXT:  linalg.matvec(%arg0, %arg1, %arg2) : !linalg.view<?x?xf32>, !linalg.view<?xf32>, !linalg.view<?xf32>
//  CHECK-NEXT:  linalg.dot(%arg1, %arg2, %arg3) : !linalg.view<?xf32>, !linalg.view<?xf32>, !linalg.view<f32>

func @dim(%arg0: !linalg.view<?x?xf32>) {
  %0 = linalg.dim %arg0, 1 : !linalg.view<?x?xf32>
  %1 = linalg.buffer_alloc %0 : !linalg.buffer<f32>
  linalg.buffer_dealloc %1 : !linalg.buffer<f32>
  return
}
// CHECK-LABEL: func @dim(%arg0: !linalg.view<?x?xf32>) {
//  CHECK-NEXT:   %0 = linalg.dim %arg0, 1 : !linalg.view<?x?xf32>
//  CHECK-NEXT:   %1 = linalg.buffer_alloc %0 : !linalg.buffer<f32>
//  CHECK-NEXT:   linalg.buffer_dealloc %1 : !linalg.buffer<f32>

func @range_intersect(%arg0: !linalg.range, %arg1: !linalg.range) -> !linalg.range {
  %0 = linalg.range_intersect %arg0, %arg1 : !linalg.range
  return %0 : !linalg.range
}
// CHECK-LABEL: func @range_intersect(%arg0: !linalg.range, %arg1: !linalg.range) -> !linalg.range {
//  CHECK-NEXT:   %0 = linalg.range_intersect %arg0, %arg1 : !linalg.range
//  CHECK-NEXT:   return %0 : !linalg.range
