module flip_flop (
    input CLK,
    input D,
    input SET,
    input CLR,
    output reg Q
);

always @(posedge CLK) begin
    if (SET) Q <= 1'b1;
    else if (CLR) Q <= 1'b0;
    else Q <= D;
end

endmodule