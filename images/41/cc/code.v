module top_module(
    input clk,
    input reset,
    input enable,
    output reg [3:0] Q
);reg [3:0] Q_reg1;
reg [3:0] Q_reg2;
reg [3:0] Q_reg3;

always @(posedge clk) begin
    if (reset) begin
        Q_reg1 <= 4'b0;
        Q_reg2 <= 4'b0;
        Q_reg3 <= 4'b0;
    end else if (enable) begin
        Q_reg1 <= Q;
        Q_reg2 <= Q_reg1;
        Q_reg3 <= Q_reg2;
        Q <= Q_reg3 + 1;
    end
end

endmodule