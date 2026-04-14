module top_module(
    input clk,
    input reset,
    output reg [31:0] count);always @(posedge clk) begin
    if (reset)
        count <= 32'hFFFFFFFF;
    else
        count <= count - 1;
end
endmodule