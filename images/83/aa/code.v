module top_module(
    input clk,
    input Up,
    input Down,
    output reg [3:0] Q
);reg [3:0] Q_reg1, Q_reg2;

always @(posedge clk) begin
    Q_reg1 <= Q;
end

always @(posedge clk) begin
    Q_reg2 <= Q_reg1;
end

always @(posedge clk) begin
    if (Up && !Down) begin
        if (Q_reg2 == 4'b1111) begin
            Q <= 4'b0000;
        end else begin
            Q <= Q_reg2 + 1;
        end
    end else if (!Up && Down) begin
        if (Q_reg2 == 4'b0000) begin
            Q <= 4'b1111;
        end else begin
            Q <= Q_reg2 - 1;
        end
    end else begin
        Q <= Q_reg2;
    end
end

endmodule