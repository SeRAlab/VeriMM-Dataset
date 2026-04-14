module top_module(
    input A,
    input B,
    input SEL,
    input VPWR,
    input VGND,
    output VOUT,
    output VOUT_N
);wire mux_out;
    // Instantiate the Multiplexer
    assign mux_out = (SEL) ? B : A;  // Simple 2:1 multiplexer logic
    
    assign VOUT = mux_out;
    assign VOUT_N = ~mux_out;

endmodule