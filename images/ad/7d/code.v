module top_module(
    input clk,
    input enable,
    output reg [11:0] count);always @(posedge clk) begin
    if (enable)
        count <= count + 1;
end
endmodule