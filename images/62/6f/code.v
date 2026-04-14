module top_module( Din, Dout, Wen, Ren, rst, ck, Fempty, Ffull );input [7:0] Din;
output [7:0] Dout;
input Wen,Ren,rst,ck;
output Fempty,Ffull;

reg  [7:0] FMEM[0:15];
reg  [3:0] Wp, Rp;
reg  Fempty, Ffull;
reg  [7:0] obuf;
wire [3:0] NWp, NRp;

assign NWp = Wp + 1;
assign NRp = Rp + 1;
assign Dout = obuf;
always @(posedge ck) begin
if( !rst ) begin
    Wp <= 0;
    Rp <= 0;
    Fempty <= 1;
    Ffull <= 0;
end else begin
    if( Ren == 1 && Fempty != 1 ) begin
        obuf <= FMEM[Rp];
        Rp <= NRp;
        Ffull <= 0;
        if( NRp == Wp ) Fempty <= 1;
        else Fempty <= 0;
    end
    if( Wen == 1 && Ffull != 1 ) begin
        FMEM[Wp] <= Din;
        Wp <= NWp;
        Fempty <= 0;
        if(NWp == Rp) Ffull <= 1;
        else Ffull <= 0;
    end
end
end
endmodule