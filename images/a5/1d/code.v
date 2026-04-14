module top_module(CLK, D, SET, RESET, Q, QN);input CLK;
input D;
input SET;
input RESET;
output Q;
output QN;

reg Q;

always @(posedge CLK) begin
    if (SET) begin
        Q <= 1'b1;
    end else if (RESET) begin
        Q <= 1'b0;
    end else begin
        Q <= D;
    end
end

assign QN = ~Q;

endmodule