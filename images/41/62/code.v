module top_module(
    input wire [7:0] gray_input,
    output reg [7:0] bin_out
);always@(*) begin
    bin_out[7] = gray_input[7];
    bin_out[6] = bin_out[7] ^ gray_input[6];
    bin_out[5] = bin_out[6] ^ gray_input[5];
    bin_out[4] = bin_out[5] ^ gray_input[4];
    bin_out[3] = bin_out[4] ^ gray_input[3];
    bin_out[2] = bin_out[3] ^ gray_input[2];
    bin_out[1] = bin_out[2] ^ gray_input[1];
    bin_out[0] = bin_out[1] ^ gray_input[0];
end

endmodule