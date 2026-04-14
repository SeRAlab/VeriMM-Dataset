module DFlipFlop (
    input clk,
    input rst_n,
    input enable,
    input d,
    output reg q
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            q <= 1'b0;
        end else if (enable) begin
            q <= d;
        end
    end
endmodule