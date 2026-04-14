module top_module(
    input  D   ,
    output reg Q   ,  // Changed to reg for sequential logic
    output Q_N ,
    input  SCD ,
    input  SCE ,
    input  CLK ,
    input  VPB ,
    input  VPWR,
    input  VGND,
    input  VNB
);wire D_ff;

assign D_ff = SCE ? SCD : D;

always @(posedge CLK) begin
    Q <= D_ff;  // 'Q' must be assigned as it is now a reg type
end

assign Q_N = ~Q;  // Directly use Q for Q_N

endmodule