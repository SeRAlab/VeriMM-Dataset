module top_module( 
    input wire [15:0] in,
    output wire [7:0] out_hi,
    output wire [7:0] out_lo );wire [7:0] shift_out;
    
    // First 8 bits
    assign shift_out[7] = in[15];
    assign shift_out[6:0] = in[14:8];
    
    // Second 8 bits
    assign out_hi[7] = shift_out[7];
    assign out_hi[6:0] = shift_out[6:0] ^ in[7:0];
    assign out_lo[7:0] = in[7:0];
    
endmodule