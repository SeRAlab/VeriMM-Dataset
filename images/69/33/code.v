module top_module(
    input clk,
    input reset,
    input enable,
    output reg [3:0] Q
);always @(posedge clk) begin
        if (reset) begin
            Q <= 4'b0000;
        end else if (enable) begin
            if (Q == 4'b1111) begin
                Q <= 4'b0000;
            end else begin
                Q <= Q + 1;
            end
        end
    end

endmodule