module top_module(
    input clk,
    output reg [3:0] Q
);reg [3:0] Q_reg1, Q_reg2, Q_reg3;

always @(posedge clk) begin
    Q_reg1 <= Q;
end

always @(posedge clk) begin
    Q_reg2 <= Q_reg1;
end

always @(posedge clk) begin
    Q_reg3 <= Q_reg2;
end

always @(posedge clk) begin
    if (Q_reg3 == 4'b1111) begin
        Q <= 4'b0000;
    end else begin
        Q <= Q_reg3 + 1;
    end
end

endmodule