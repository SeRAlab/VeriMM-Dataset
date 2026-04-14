module top_module(
    input  rst,
    input  [3:0] bin_in,
    output [3:0] gray_out
);wire [3:0] shift_right;
    
    assign shift_right[0] = bin_in[0];
    assign shift_right[1] = bin_in[0] ^ bin_in[1];
    assign shift_right[2] = bin_in[1] ^ bin_in[2];
    assign shift_right[3] = bin_in[2] ^ bin_in[3];
    
    assign gray_out = {bin_in[3], shift_right[3], shift_right[2], shift_right[1]};

endmodule