module top_module(CLK, LOAD, D, SHIFT, Q, Qbar);input CLK, LOAD, SHIFT;
input [3:0] D;
output [3:0] Q, Qbar;

reg [3:0] Q_reg, Qbar_reg;

always @(posedge CLK) begin
    if (LOAD) begin
        Q_reg <= D;
        Qbar_reg <= ~D;
    end else if (SHIFT) begin
        Q_reg <= {Q_reg[2:0], 1'b0};
        Qbar_reg <= {Qbar_reg[2:0], 1'b1};
    end
end

assign Q = Q_reg;
assign Qbar = Qbar_reg;

endmodule