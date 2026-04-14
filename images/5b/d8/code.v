module verified_bin_to_gray(
    input [3:0] bin_in,
    
    output reg [3:0] gray_out
);
    always @(*) begin
        gray_out[3] = bin_in[3];
        gray_out[2] = bin_in[3] ^ bin_in[2];
        gray_out[1] = bin_in[2] ^ bin_in[1];
        gray_out[0] = bin_in[1] ^ bin_in[0];
    end
endmodule