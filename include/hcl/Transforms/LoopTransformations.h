//===----------------------------------------------------------------------===//
//
// Copyright 2020-2021 The HCL-MLIR Authors.
//
//===----------------------------------------------------------------------===//

#ifndef HETEROCL_LOOPTRANSFORMATIONS_H
#define HETEROCL_LOOPTRANSFORMATIONS_H

#include "mlir/Dialect/StandardOps/IR/Ops.h"
#include "mlir/Pass/Pass.h"
#include "mlir/Pass/PassRegistry.h"

#include "hcl/Dialect/HeteroCLOps.h"

namespace mlir {
namespace hcl {

void registerHCLLoopTransformationPass();
std::unique_ptr<mlir::Pass> createHCLLoopTransformationPass();

bool applyLoopTransformation(ModuleOp &f);

} // namespace hcl
} // namespace mlir

#endif // HETEROCL_LOOPTRANSFORMATIONS_H