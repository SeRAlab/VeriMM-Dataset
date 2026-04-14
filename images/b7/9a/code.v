module top_module(
    input clk,
    input [3:0] D,
    input UD,
    input CE,
    output reg [3:0] Q
);always @(posedge clk) begin
        if (CE) begin
            if (UD) begin
                Q <= Q + 1;
            end else begin
                Q <= Q - 1;
            end
        end else begin
            Q <= D;
        end
    end

endmodule