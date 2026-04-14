module top_module(
    input wire [15:0] in,
    input wire select_upper,
    output wire [7:0] out_hi,
    output wire [7:0] out_lo);wire [7:0] shifted_in;
    
    // Barrel shifter to shift input to the right by 8 bits
    assign shifted_in = in >> 8;
    
    // Multiplexer to select upper or lower byte based on select_upper signal
    assign out_hi = select_upper ? shifted_in : in[15:8];
    assign out_lo = select_upper ? in[7:0] : shifted_in;
    
endmodule