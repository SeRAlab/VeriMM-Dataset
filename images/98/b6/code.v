module top_module(
    input [3:0] in,
    output [3:0] out
);// Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB ;
    supply0 VNB ;

    // Invert MSB
    assign out[2:0] = in[2:0]; 
    assign out[3] = ~in[3];  // Directly invert MSB instead of using unknown module

endmodule