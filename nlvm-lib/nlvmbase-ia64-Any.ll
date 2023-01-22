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

@stdout = global ptr null
declare i32 @vprintf(ptr, ptr)

declare void @llvm.memcpy.p0.p0.i64(ptr noalias nocapture writeonly, ptr noalias nocapture readonly, i64, i1 immarg)
declare void @llvm.memset.p0.i64(ptr nocapture writeonly, i8, i64, i1 immarg)

declare ptr @malloc(i64 %size)
declare void @free(ptr %mem)

define ptr @realloc(ptr %mem, i64 %size) #0 {
secAlloca:
  %result = alloca ptr, align 8
  %arg.mem = alloca ptr, align 8
  %arg.size = alloca i64, align 8
  br label %secArgs

secArgs:                                          ; preds = %secAlloca
  store ptr null, ptr %result, align 8
  store ptr %mem, ptr %arg.mem, align 8
  store i64 %size, ptr %arg.size, align 8
  br label %secBody

secBody:                                          ; preds = %secArgs
  %load.arg.size = load i64, ptr %arg.size, align 8
  %call.res.runtime.nim.125.21 = call ptr @malloc(i64 %load.arg.size)
  store ptr %call.res.runtime.nim.125.21, ptr %result, align 8
  %load.result.runtime.nim.126.7 = load ptr, ptr %result, align 8
  %icmp.IntEQ.runtime.nim.126.14 = icmp eq ptr %load.result.runtime.nim.126.7, null
  %bool.i8.icmp.IntEQ.runtime.nim.126.14 = zext i1 %icmp.IntEQ.runtime.nim.126.14 to i8
  %not.bool.i8.icmp.IntEQ.runtime.nim.126.14 = icmp eq i8 %bool.i8.icmp.IntEQ.runtime.nim.126.14, 0
  %zext.not.bool.i8.icmp.IntEQ.runtime.nim.126.14 = zext i1 %not.bool.i8.icmp.IntEQ.runtime.nim.126.14 to i8
  %i1.zext.not.bool.i8.icmp.IntEQ.runtime.nim.126.14 = icmp ne i8 %zext.not.bool.i8.icmp.IntEQ.runtime.nim.126.14, 0
  br i1 %i1.zext.not.bool.i8.icmp.IntEQ.runtime.nim.126.14, label %if.true.runtime.nim.126.4, label %if.false.runtime.nim.126.4

if.true.runtime.nim.126.4:                        ; preds = %secBody
  %load.result.runtime.nim.127.14 = load ptr, ptr %result, align 8
  %load.arg.mem = load ptr, ptr %arg.mem, align 8
  %load.arg.size1 = load i64, ptr %arg.size, align 8
  %rng.ugt = icmp ugt i64 %load.arg.size1, 9223372036854775807
  br i1 %rng.ugt, label %raise.call.rng.ugt, label %raise.cont.rng.ugt

raise.call.rng.ugt:                               ; preds = %if.true.runtime.nim.126.4
  br label %secReturn

raise.cont.rng.ugt:                               ; preds = %if.true.runtime.nim.126.4
  call void @llvm.memcpy.p0.p0.i64(ptr %load.result.runtime.nim.127.14, ptr %load.arg.mem, i64 %load.arg.size1, i1 false)
  %load.arg.mem2 = load ptr, ptr %arg.mem, align 8
  call void @free(ptr %load.arg.mem2)
  br label %if.end.runtime.nim.126.4

if.false.runtime.nim.126.4:                       ; preds = %secBody
  br label %if.end.runtime.nim.126.4

if.end.runtime.nim.126.4:                         ; preds = %if.false.runtime.nim.126.4, %raise.cont.rng.ugt
  br label %secReturn

secReturn:                                        ; preds = %if.end.runtime.nim.126.4
  %load.result = load ptr, ptr %result, align 8
  ret ptr %load.result
}

define ptr @calloc(i64 %nmemb, i64 %size) #0 {
secAlloca:
  %result = alloca ptr, align 8
  %arg.nmemb = alloca i64, align 8
  %arg.size = alloca i64, align 8
  %size1 = alloca i64, align 8
  br label %secArgs

secArgs:                                          ; preds = %secAlloca
  store ptr null, ptr %result, align 8
  store i64 %nmemb, ptr %arg.nmemb, align 8
  store i64 %size, ptr %arg.size, align 8
  br label %secBody

secBody:                                          ; preds = %secArgs
  %load.arg.nmemb = load i64, ptr %arg.nmemb, align 8
  %load.arg.size = load i64, ptr %arg.size, align 8
  %binop.Mul.runtime.nim.120.20 = mul i64 %load.arg.nmemb, %load.arg.size
  store i64 %binop.Mul.runtime.nim.120.20, ptr %size1, align 8
  %load.size1.runtime.nim.121.22 = load i64, ptr %size1, align 8
  %call.res.runtime.nim.121.21 = call ptr @malloc(i64 %load.size1.runtime.nim.121.22)
  store ptr %call.res.runtime.nim.121.21, ptr %result, align 8
  %load.result.runtime.nim.122.12 = load ptr, ptr %result, align 8
  %load.size1.runtime.nim.122.20 = load i64, ptr %size1, align 8
  %rng.ugt = icmp ugt i64 %load.size1.runtime.nim.122.20, 9223372036854775807
  br i1 %rng.ugt, label %raise.call.rng.ugt, label %raise.cont.rng.ugt

raise.call.rng.ugt:                               ; preds = %secBody
  br label %secReturn

raise.cont.rng.ugt:                               ; preds = %secBody
  call void @llvm.memset.p0.i64(ptr %load.result.runtime.nim.122.12, i8 0, i64 %load.size1.runtime.nim.122.20, i1 false)
  br label %secReturn

secReturn:                                        ; preds = %raise.cont.rng.ugt
  %load.result = load ptr, ptr %result, align 8
  ret ptr %load.result
}

define i64 @fwrite(ptr %data, i64 %size, i64 %nmemb, ptr %file) #0 {
secAlloca:
  %result = alloca i64, align 8
  %arg.data = alloca ptr, align 8
  %arg.size = alloca i64, align 8
  %arg.nmemb = alloca i64, align 8
  %arg.file = alloca ptr, align 8
  %call.res.ptr.runtime.nim.133.13 = alloca i32, align 4
  br label %secArgs

secArgs:                                          ; preds = %secAlloca
  store i64 0, ptr %result, align 8
  store ptr %data, ptr %arg.data, align 8
  store i64 %size, ptr %arg.size, align 8
  store i64 %nmemb, ptr %arg.nmemb, align 8
  store ptr %file, ptr %arg.file, align 8
  br label %secBody

secBody:                                          ; preds = %secArgs
  %load.arg.data = load ptr, ptr %arg.data, align 8
  %call.res.runtime.nim.133.13 = call i32 @vprintf(ptr %load.arg.data, ptr null)
  store i32 %call.res.runtime.nim.133.13, ptr %call.res.ptr.runtime.nim.133.13, align 4
  br label %secReturn

secReturn:                                        ; preds = %secBody
  %load.result = load i64, ptr %result, align 8
  ret i64 %load.result
}

define i32 @fflush(ptr %file) #0 {
secAlloca:
  %result = alloca i32, align 4
  %arg.file = alloca ptr, align 8
  br label %secArgs

secArgs:                                          ; preds = %secAlloca
  store i32 0, ptr %result, align 4
  store ptr %file, ptr %arg.file, align 8
  br label %secBody

secBody:                                          ; preds = %secArgs
  br label %secReturn

secReturn:                                        ; preds = %secBody
  %load.result = load i32, ptr %result, align 4
  ret i32 %load.result
}


attributes #0 = {alwaysinline nounwind}
