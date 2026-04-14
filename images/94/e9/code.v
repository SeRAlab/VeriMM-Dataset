module top_module(
    input clk,
    input reset,
    input enable,
    input [3:0] in,
    output reg [1:0] out
);reg [3:0] count;

    always @(posedge clk) begin
        if (reset) begin
            count <= 0;
        end else if (enable) begin
            count <= count + 1;
        end
    end

    always @(posedge clk) begin
        if (enable) begin
            out <= count[1:0];
        end
    end

endmodule