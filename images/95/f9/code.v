module top_module(
    input clk,
    input [3:0] DIN,
    input LOAD,
    input SHIFT,
    input RESET,
    output reg [3:0] Q
);always @(posedge clk) begin
        if (RESET) begin
            Q <= 4'b0;
        end else if (LOAD) begin
            Q <= DIN;
        end else if (SHIFT) begin
            Q <= {Q[2:0], 1'b0};
        end
    end

endmodule