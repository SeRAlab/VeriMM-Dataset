module top_module(
    input A,
    input B,
    input C,
    input D,
    output X
);wire X_int;
    // Assuming the sky130_fd_sc_lp__and4 is an external module that needs to be included.
    // If it's part of a library, ensure that the library is referenced properly.
    // For this example, we can define a simple 4-input AND gate if the external module is unavailable.
    
    // Uncomment the line below to use the external module when you have the correct library included
    // sky130_fd_sc_lp__and4 base (.X(X_int), .A(A), .B(B), .C(C), .D(D), .VPWR(1'b1), .VGND(1'b0), .VPB(1'b0), .VNB(1'b0));
    
    // Simple 4-input AND gate implementation
    assign X_int = A & B & C & D; 
    
    assign X = X_int;

endmodule