module top_module(
    output X,
    input  A1,
    input  A2,
    input  B1,
    input  B2,
    input  VPWR,
    input  VGND,
    input  VPB,
    input  VNB
);// Instantiate an alternative module if sky130_fd_sc_lp__o22a is not available
    // Replacing with a simple 2-input OR gate for demonstration.
    wire A1_B1_or;
    wire A2_B2_or;
    
    assign A1_B1_or = A1 | B1;
    assign A2_B2_or = A2 | B2;
    assign X = A1_B1_or & A2_B2_or;

    // If you have access to the actual sky130_fd_sc_lp library,
    // please ensure that the library is correctly included in your project.

endmodule