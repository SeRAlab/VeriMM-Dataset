module top_module(
    input clk, rst_n,
    input [3:0] bin_in,
    output reg [3:0] gray_out
);always @(posedge clk) begin
    if(rst_n == 0) begin
        gray_out <= 4'b0000;
    end else begin
        gray_out <= {bin_in[3] ^ bin_in[2], bin_in[2] ^ bin_in[1], bin_in[1] ^ bin_in[0], bin_in[0]};
    end
end

endmodule