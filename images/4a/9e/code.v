module top_module(
    output reg Q   , // Changed to output reg
    output wire Q_N , // Changed to output wire
    input  CLK ,
    input  D   ,
    input  SCD ,
    input  SCE ,
    input  VPWR,
    input  VGND,
    input  VPB ,
    input  VNB 
);assign Q_N = ~Q;
    
    always @(posedge CLK) begin
        if (SCD && ~SCE) begin
            Q <= 1'b1;
        end else if (~SCD && SCE) begin
            Q <= 1'b0;
        end else if (~SCD && ~SCE) begin
            Q <= D;
        end else if (SCD && SCE) begin
            Q <= 1'b0;
        end
    end
    
endmodule