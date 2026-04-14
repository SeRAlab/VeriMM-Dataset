module top_module(
    input clk,
    input en,
    input [1:0] compare_val,
    output reg [3:0] Q,
    output reg comp_out
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
    if (en) begin
        Q <= Q_reg3 + 1;
    end else begin
        Q <= Q;
    end
end

always @(posedge clk) begin
    if (Q >= compare_val) begin
        comp_out <= 1;
    end else begin
        comp_out <= 0;
    end
end

endmodule