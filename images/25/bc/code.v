module DFlipFlop (
    input wire D,
    input wire clk,
    input wire reset,
    input wire clk_enable,
    output reg Q
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            Q <= 0;
        end else if (clk_enable) begin
            Q <= D;
        end
    end
endmodule