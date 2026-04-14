module top_module(
    input [3:0] D,
    input SHL,
    input SHR,
    input LOAD,
    input clk,      // Added clock input
    output reg [3:0] Q
);reg [3:0] Q_reg;
reg [3:0] Q_next;

always @(*) begin
    Q_next = Q_reg;
    if (LOAD) begin
        Q_next = D;
    end else if (SHL) begin
        Q_next[3:1] = Q_reg[2:0];
        Q_next[0] = 0;
    end else if (SHR) begin
        Q_next[2:0] = Q_reg[3:1];
        Q_next[3] = 0;
    end
end

always @(posedge clk) begin
    Q_reg <= Q_next;
end

assign Q = Q_reg;

endmodule