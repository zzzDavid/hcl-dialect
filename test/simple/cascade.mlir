// RUN: hcl-opt %s | hcl-opt | FileCheck %s

module {
    func @matrix_multiply(%A: memref<1024x1024xf32>, %B: memref<1024x1024xf32>, %C: memref<1024x1024xf32>) -> memref<1024x1024xf32>
    {
        %l1 = hcl.create_loop_handle "i" : !hcl.LoopHandle
        %l2 = hcl.create_loop_handle "j" : !hcl.LoopHandle
        %l3 = hcl.create_loop_handle "k" : !hcl.LoopHandle
        %s = hcl.create_stage_handle "s" : !hcl.StageHandle
        affine.for %i = 0 to 1024 {
            affine.for %j = 0 to 1024 {
                affine.for %k = 0 to 1024 {
                    %a = affine.load %A[%i, %k] : memref<1024x1024xf32>
                    %b = affine.load %B[%k, %j] : memref<1024x1024xf32>
                    %c = affine.load %C[%i, %j] : memref<1024x1024xf32>
                    %prod = mulf %a, %b : f32
                    %sum = addf %prod, %c: f32
                    affine.store %sum, %C[%i, %j] : memref<1024x1024xf32>
                } { loop_name = "k" }
            } { loop_name = "j" }
        } { loop_name = "i", stage_name = "s" }
        %l4, %l5 = hcl.split (%s: !hcl.StageHandle, %l1: !hcl.LoopHandle, 8) -> (!hcl.LoopHandle, !hcl.LoopHandle)
        %l6, %l7, %l8, %l9 = hcl.tile (%s: !hcl.StageHandle, %l2: !hcl.LoopHandle, %l3: !hcl.LoopHandle, 2, 4) -> (!hcl.LoopHandle, !hcl.LoopHandle, !hcl.LoopHandle, !hcl.LoopHandle) // split & tile
        %l10, %l11 = hcl.split (%s: !hcl.StageHandle, %l6: !hcl.LoopHandle, 16) -> (!hcl.LoopHandle, !hcl.LoopHandle)
        hcl.partition(%A: memref<1024x1024xf32>, "CyclicPartition", 0, 4)
        hcl.partition(%B: memref<1024x1024xf32>, "BlockPartition", 0, 2)
        return %C : memref<1024x1024xf32>
    }
}