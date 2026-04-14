module top_module(
input clk, reset, en_write,
input[BIT_WIDTH - 1: 0] data_in,
output reg signed [BIT_WIDTH - 1: 0] data_out
);parameter BIT_WIDTH = 32;
parameter RESET_VALUE = 0;

always @(posedge clk) begin
    if (reset == 1'b1)
        data_out <= RESET_VALUE;
    else if (en_write == 1'b1)
        data_out <= data_in;
end

endmodule