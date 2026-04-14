module top_module(
    output reg Q   ,
    output reg Q_N ,
    input  CLK     ,
    input  D       ,
    input  VPWR    ,
    input  VGND    ,
    input  VPB     ,
    input  VNB
);// D Flip-Flop logic
    always @(posedge CLK or negedge VPWR) begin
        if (VPWR) begin
            Q <= D;
            Q_N <= ~D;
        end
    end

endmodule