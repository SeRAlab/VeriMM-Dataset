module top_module(
    input clk,
    input UP,
    input DOWN,
    input LOAD,
    input [3:0] DIN,
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
    if (LOAD) begin
        Q_reg1 <= DIN;
        Q_reg2 <= DIN;
        Q_reg3 <= DIN;
    end else if (UP) begin
        if (Q_reg1 == 4'b1111) begin
            Q_reg1 <= 4'b0000;
            Q_reg2 <= 4'b0000;
            Q_reg3 <= 4'b0000;
        end else begin
            Q_reg1 <= Q_reg1 + 1;
            Q_reg2 <= Q_reg2 + 1;
            Q_reg3 <= Q_reg3 + 1;
        end
    end else if (DOWN) begin
        if (Q_reg1 == 4'b0000) begin
            Q_reg1 <= 4'b1111;
            Q_reg2 <= 4'b1111;
            Q_reg3 <= 4'b1111;
        end else begin
            Q_reg1 <= Q_reg1 - 1;
            Q_reg2 <= Q_reg2 - 1;
            Q_reg3 <= Q_reg3 - 1;
        end
    end
end

assign Q = Q_reg3;

endmodule