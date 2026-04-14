module top_module(
    input [2:0] bin_in,
    output reg [2:0] gray_out
);always @(*) begin
        gray_out[0] = bin_in[0] ^ bin_in[1];
        gray_out[1] = bin_in[1] ^ bin_in[2];
        gray_out[2] = bin_in[2];
    end

endmodule