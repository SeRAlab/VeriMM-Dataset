module top_module(
    input wire [15:0] in,
    output wire [7:0] out_hi,
    output wire [7:0] out_lo
);wire [7:0] shifted_in;
    
    assign shifted_in = in >> 8;
    
    assign out_hi = shifted_in;
    
    assign out_lo = in[7:0];
    
endmodule