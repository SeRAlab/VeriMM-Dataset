module top_module(
    input [3:0] bin_in,
    input clk,
    output reg [3:0] gray_out
);// Combinational logic block for binary to gray code conversion
    always @* begin
        gray_out[0] = bin_in[0] ^ bin_in[1];
        gray_out[1] = bin_in[1] ^ bin_in[2];
        gray_out[2] = bin_in[2] ^ bin_in[3];
        gray_out[3] = bin_in[3];
    end

    // Edge-triggered flip-flop for storing the output value
    always @(posedge clk) begin
        gray_out <= gray_out;
    end

endmodule