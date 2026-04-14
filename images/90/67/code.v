module top_module(
    input wire [15:0] in,
    input wire SEL,
    input wire A,
    input wire B,
    output wire [7:0] out_hi,
    output wire [7:0] out_lo,
    output wire Y,
    output wire [7:0] OR_output
);// Barrel shifter
    assign out_hi = in[15:8];
    assign out_lo = in[7:0];
    
    // 2:1 Multiplexer
    assign Y = SEL ? B : A;
    
    // Bitwise OR
    assign OR_output = out_hi | out_lo | Y;

endmodule