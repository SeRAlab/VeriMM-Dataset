module top_module(
    input clk,
    input [99:0] in_port,
    output reg [99:0] out_port,
    input enable,
    input reset
);always @(posedge clk) begin
    if (reset) begin
        out_port <= 0;
    end else if (enable) begin
        out_port <= in_port;
    end
end

endmodule