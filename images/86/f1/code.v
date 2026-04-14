module top_module(
    input A,
    input B,
    input C_N,
    output X,
    input VPWR,
    input VGND,
    input VPB,
    input VNB
);wire AB, ABC_N;

// Assign the OR gate logic
assign AB = A | B;
assign ABC_N = AB | C_N;
assign X = ABC_N;

// Check if the required library is included for the module
// If available, instantiate the OR gate here

// Assuming the library has the OR gate, e.g., sky130_fd_sc_hdll__or3b_4,
// you will need to ensure the module name and port connections match the library definition.
// To avoid compilation errors, ensure the library files are included during simulation.
/*
sky130_fd_sc_hdll__or3b_4 base (
    .X(X),
    .A(A),
    .B(B),
    .C_N(C_N),
    .VPWR(VPWR),
    .VGND(VGND),
    .VPB(VPB),
    .VNB(VNB)
);
*/

endmodule