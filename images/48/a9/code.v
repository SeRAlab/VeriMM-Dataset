module top_module(
    input CLK,
    input LOAD,
    input CLR,
    input [3:0] D,
    output reg [3:0] Q,
    output reg [3:0] Q_next
);reg [3:0] Q_reg;
reg [3:0] Q_next_reg;

always @(posedge CLK) begin
    if (CLR) begin
        Q_reg <= 4'b0;
        Q_next_reg <= 4'b0;
    end
    else if (LOAD) begin
        Q_reg <= D;
        Q_next_reg <= D;
    end
    else begin
        Q_reg <= Q_next_reg;
        Q_next_reg[0] <= Q_reg[3];
        Q_next_reg[1] <= Q_reg[0];
        Q_next_reg[2] <= Q_reg[1];
        Q_next_reg[3] <= Q_reg[2];
    end
end

assign Q = Q_reg;
assign Q_next = Q_next_reg;

endmodule