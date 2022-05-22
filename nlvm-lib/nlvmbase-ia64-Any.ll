; base presently used for nvptx64!

; user guide recommandation, but not default given by backend
;target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v16:16:16-v32:32:32-v64:64:64-v128:128:128-n16:32:64"

target datalayout = "e-i64:64-i128:128-v16:16-v32:32-n16:32:64"
target triple = "nvptx64-nvidia-cuda"

; to avoid the intricacy of defining it in nim-space
@_nim_shared_heap = external dso_local addrspace(3) global [0 x i32], align 4
define i32 addrspace(3)* @_nim_getSharedHeapRoot() #0 {
  %1 = getelementptr inbounds [0 x i32] , [0 x i32] addrspace(3)* @_nim_shared_heap, i64 0, i64 0
  ret i32 addrspace(3)* %1;
}


attributes #0 = {alwaysinline nounwind}
