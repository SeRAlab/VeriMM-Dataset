module top_module(
    out,
    D,
    Q_reg_reg,
    m_aclk,
    reset
);output [3:0] out;
input [0:0] D;
input [3:0] Q_reg_reg;
input m_aclk;
input [0:0] reset;

reg [3:0] Q_reg;

assign out = Q_reg;

always @(posedge m_aclk or posedge reset) begin
    if (reset) begin
        Q_reg <= 4'b0000;
    end else begin
        Q_reg <= Q_reg_reg;
    end
end

wire D_wire;
assign D_wire = (Q_reg[2] & ~Q_reg[3]) | (Q_reg[3] & Q_reg[2]); // Logic equivalent to LUT2 with INIT 4'h6
assign D = D_wire;

endmodule