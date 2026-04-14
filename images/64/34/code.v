module top_module(
    input clk,
    input reset,
    input [7:0] A,
    input [7:0] B,
    output reg [15:0] P
);reg [7:0] multiplier_reg;
reg [3:0] counter_reg;

always @(posedge clk) begin
    if (reset) begin
        multiplier_reg <= 8'b0;
        counter_reg <= 4'b0;
        P <= 16'b0;
    end else begin
        if (counter_reg == 4'b0) begin
            multiplier_reg <= B;
            counter_reg <= 4'b1;
        end else begin
            {P[15:8], P[7:0]} <= P + (A << counter_reg);
            counter_reg <= counter_reg + 1;
        end
    end
end

endmodule