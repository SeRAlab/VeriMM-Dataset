module bin2gray(
    input [2:0] bin_in,
    output [2:0] gray_out
);

// Implement the gray code conversion using behavioral modeling
always @(*) begin
    gray_out[2] = bin_in[2];
    gray_out[1] = bin_in[2] ^ bin_in[1];
    gray_out[0] = bin_in[1] ^ bin_in[0];
end

endmodule