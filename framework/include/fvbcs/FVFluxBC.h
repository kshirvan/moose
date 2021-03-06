//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#pragma once

#include "FVBoundaryCondition.h"
#include "CoupleableMooseVariableDependencyIntermediateInterface.h"
#include "MaterialPropertyInterface.h"
#include "FVUtils.h"

// Provides an interface for computing residual contributions from finite
// volume numerical fluxes computed on faces to neighboring elements.
class FVFluxBC : public FVBoundaryCondition,
                 public CoupleableMooseVariableDependencyIntermediateInterface,
                 public MaterialPropertyInterface
{
public:
  FVFluxBC(const InputParameters & parameters);

  static InputParameters validParams();

  virtual void computeResidual(const FaceInfo & fi);
  virtual void computeJacobian(const FaceInfo & fi);

protected:
  virtual ADReal computeQpResidual() = 0;

  const ADRealVectorValue & normal() const { return _normal; }

  const unsigned int _qp = 0;
  const ADVariableValue & _u;
  // TODO: add gradients once we have reconstruction.
  ADRealVectorValue _normal;
  const FaceInfo * _face_info = nullptr;

private:
  /// Computes the Jacobian contribution for every coupled variable.
  ///
  /// @param type Either ElementElement, ElementNeighbor, NeighborElement, or NeighborNeighbor. As an
  /// example ElementNeighbor means the derivatives of the elemental residual with respect to the
  /// neighbor degrees of freedom
  ///
  /// @param residual The already computed residual (probably done with \p computeQpResidual) that
  /// also holds derivative information for filling in the Jacobians
  void computeJacobian(Moose::DGJacobianType type, const ADReal & residual);
};
