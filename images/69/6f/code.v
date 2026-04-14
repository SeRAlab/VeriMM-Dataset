module top_module(
    input [1:0] data,
    input clk,
    output reg q
);always @(posedge clk) begin
    q <= data[1];
end

endmodule