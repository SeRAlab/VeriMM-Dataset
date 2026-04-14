module top_module(
    input wire [15:0] in,
    input wire select,
    output wire [7:0] out_hi,
    output wire [7:0] out_lo
);wire [3:0] select_bits;
    assign select_bits = select ? 4'b1110 : 4'b0001; // Selects between upper and lower bytes based on select input
    
    wire [15:0] shifted_in;
    assign shifted_in = in << select_bits; // Shifts input based on select input
    
    assign out_hi = shifted_in[15:8]; // Outputs upper byte
    assign out_lo = shifted_in[7:0]; // Outputs lower byte

endmodule