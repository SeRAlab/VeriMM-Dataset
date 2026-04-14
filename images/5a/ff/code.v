module top_module(
    input  D   ,
    output Q   ,
    output Q_N ,
    input  DE  ,
    input  SCD ,
    input  SCE ,
    input  CLK ,
    input  VPB ,
    input  VPWR,
    input  VGND,
    input  VNB
);reg Q_reg;

    always @(posedge CLK) begin
        if (DE) begin
            Q_reg <= D;
        end
    end

    assign Q = Q_reg;
    assign Q_N = ~Q_reg;

endmodule