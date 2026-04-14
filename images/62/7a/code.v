module d_flip_flop (D, CLK, RESET, Q, QN);
input D;
input CLK;
input RESET;
output reg Q;
output QN;

always @(posedge CLK or posedge RESET) begin
    if (RESET) begin
        Q <= 1'b0;
    end
    else begin
        Q <= D;
    end
end

assign QN = ~Q;

endmodule