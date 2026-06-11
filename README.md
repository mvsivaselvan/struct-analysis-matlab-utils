# MATLAB utilities to support structural analysis

Simple MATLAB functions to support structural analysis and finite elements.

# TODO List

## Overall structure

- Code repeated in simpleFEA, getStiffAndMassMatrices and assignDisplacementToJoints; how to streamline?
- Create examples for each element
- Restriction to one element type per problem is ok for simplicity, but how to select what that element is in the input file?

## 2D Truss
- Make consistent with 3D beam function calls

## 3D Truss
- Make consistent with 3D beam function calls

## Membrane
- Find python script that reads coord and connect from ABAQUS and add to repository
- Add kinematic constraint in input file