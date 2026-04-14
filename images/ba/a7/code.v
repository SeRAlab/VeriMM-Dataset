module top_module(
    input clk,
    input reset,
    input enable,
    input [7:0] data_in,
    output reg [7:0] reg_out);always @(posedge clk) begin
    if (reset)
        reg_out <= 8'b0;
    else if (enable)
        reg_out <= data_in;
end
endmodule