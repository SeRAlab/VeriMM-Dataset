module top_module(
    input clk,
    input U_D,
    output reg [3:0] Q
);reg [3:0] Q_reg1;
reg [3:0] Q_reg2;

always @(posedge clk) begin
    Q_reg1 <= Q;
end

always @(posedge clk) begin
    Q_reg2 <= Q_reg1;
end

always @(posedge clk) begin
    if (U_D) begin
        Q <= Q_reg2 + 1;
    end else begin
        Q <= Q_reg2 - 1;
    end
end

endmodule