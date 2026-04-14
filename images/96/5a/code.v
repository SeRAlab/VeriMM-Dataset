module d_ff(D, CLK, Q);
input D;
input CLK;
output reg Q;

always @(posedge CLK) begin
    Q <= D;
end

endmodule