module d_flip_flop (
    input D,
    input Clk,
    input Reset,
    output reg Q
);

always @(posedge Clk or posedge Reset) begin
    if (Reset)
        Q <= 1'b0;
    else
        Q <= D;
end

endmodule