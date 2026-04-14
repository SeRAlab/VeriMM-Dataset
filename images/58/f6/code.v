module d_flip_flop(CLK,SRST,D,Q);
input CLK,SRST,D;
output Q;
reg Q;

always@(posedge CLK) begin
    if (SRST)
        Q <= 0;
    else
        Q <= D;
end

endmodule