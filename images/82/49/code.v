module d_flip_flop_1bit(D, CLK, RESET, Q);
input D, CLK, RESET;
output reg Q;

always @(posedge CLK or posedge RESET) begin
    if (RESET)
        Q <= 1'b0;
    else
        Q <= D;
end

endmodule