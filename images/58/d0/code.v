module d_ff(CLK, RST, D, Q);
input CLK, RST, D;
output Q;
reg Q;

always @(posedge CLK or posedge RST) begin
    if (RST)
        Q <= 1'b0;
    else
        Q <= D;
end

endmodule