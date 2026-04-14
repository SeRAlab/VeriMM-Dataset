module top_module(
    input D,
    input GATE_N,
    input VPWR,
    input VGND,
    input VPB,
    input VNB,
    input clk,
    output reg Q
);reg Q_reg;
wire clock_edge;

assign clock_edge = clk & ~Q_reg;

always @(posedge clock_edge) begin
    if (!GATE_N) begin
        Q_reg <= D;
    end
end

always @(GATE_N or VPWR or VGND or VPB or VNB) begin
    if (GATE_N) begin
        Q = 1'b0;
    end else begin
        Q = Q_reg;
    end
end

endmodule