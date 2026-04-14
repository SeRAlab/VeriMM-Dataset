module top_module(
    input [3:0] bin_in,
    output reg [3:0] gray_out
);assign gray_out[3] = bin_in[3]; // MSB of gray code is same as MSB of binary code

always @(*) begin
    gray_out[2] = bin_in[3] ^ bin_in[2]; // second bit is XOR of MSB and second bit of binary
    gray_out[1] = bin_in[2] ^ bin_in[1]; // third bit is XOR of second and third bit of binary
    gray_out[0] = bin_in[1] ^ bin_in[0]; // fourth bit is XOR of third and fourth bit of binary
end

endmodule