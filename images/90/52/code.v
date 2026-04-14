module top_module(
    input clk,
    input rst,
    input load,
    input [1:0] D,
    output reg [1:0] Q
);always @(posedge clk) begin
        if (rst) begin
            Q <= 2'b0;
        end else if (load) begin
            Q <= D;
        end else begin
            Q <= Q + D;
        end
    end

endmodule