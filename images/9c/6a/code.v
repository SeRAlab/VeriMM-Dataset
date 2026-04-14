module d_flip_flop_1bit (CLK, RESET, D, Q);
input CLK;
input RESET;
input D;
output reg Q;

always @(posedge CLK or posedge RESET) begin
    if (RESET) begin
        Q <= 1'b0;
    end
    else begin
        Q <= D;
    end
end

endmodule