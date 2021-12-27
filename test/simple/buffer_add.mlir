// RUN: hcl-opt %s | hcl-opt | FileCheck %s

module {
    func @add_buffer_at_axis_0(%A: memref<1024x1024xf32>, %B: memref<1024x1024xf32>, %C: memref<1024x1024xf32>) -> memref<1024x1024xf32>
    {
        %l1 = hcl.create_loop_handle "i" : !hcl.LoopHandle
        %l2 = hcl.create_loop_handle "j" : !hcl.LoopHandle
        %s = hcl.create_stage_handle "s" : !hcl.StageHandle
        affine.for %i = 0 to 1024 {
            affine.for %j = 0 to 1024 {
                // B[i, j] = A[i, j] + 1
                %a = affine.load %A[%i, %j] : memref<1024x1024xf32>
                %cst = constant 1.0 : f32
                %sum = addf %a, %cst: f32 //register
                affine.store %sum, %B[%i, %j] : memref<1024x1024xf32>
            } { loop_name = "j" }
        } { loop_name = "i", stage_name = "s" }
        hcl.buffer_at(%s: !hcl.StageHandle, %B: memref<1024x1024xf32>, 0)
        return %C : memref<1024x1024xf32>
    }
    func @add_buffer_at_axis_1(%A: memref<1024x1024xf32>, %B: memref<1024x1024xf32>, %C: memref<1024x1024xf32>) -> memref<1024x1024xf32>
    {
        %l1 = hcl.create_loop_handle "i" : !hcl.LoopHandle
        %l2 = hcl.create_loop_handle "j" : !hcl.LoopHandle
        %s = hcl.create_stage_handle "s" : !hcl.StageHandle
        affine.for %i = 0 to 1024 {
            affine.for %j = 0 to 1024 {
                // B[i, j] = A[i, j] + 1
                %a = affine.load %A[%i, %j] : memref<1024x1024xf32>
                %cst = constant 1.0 : f32
                %sum = addf %a, %cst: f32 //register
                affine.store %sum, %B[%i, %j] : memref<1024x1024xf32>
            } { loop_name = "j" }
        } { loop_name = "i", stage_name = "s" }
        hcl.buffer_at(%s: !hcl.StageHandle, %B: memref<1024x1024xf32>, 1)
        return %C : memref<1024x1024xf32>
    }
}