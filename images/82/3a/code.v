module top_module(
    input Clk,
    input Reset,
    input Enable,
    output reg [3:0] Q
);reg [3:0] Q_reg;
reg [3:0] Q_next;

always @(posedge Clk) begin
    if (Reset) begin
        Q_reg <= 4'b0000;
    end else if (Enable) begin
        Q_reg <= Q_next;
    end
end

always @(*) begin
    Q_next = Q_reg + 1;
end

assign Q = Q_reg;

endmodule