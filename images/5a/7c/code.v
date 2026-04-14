module top_module(
    input clk,
    input reset,
    input enable,
    input [3:0] in,
    output reg [3:0] count
);always @(posedge clk) begin
    if (reset) begin
        count <= 4'b0;
    end else if (enable) begin
        count <= count + in;
    end
end

endmodule