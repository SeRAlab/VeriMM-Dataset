module d_flipflop (D, CLK, RST, EN, Q);
input D, CLK, RST, EN;
output reg Q;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Q <= 1'b0;
    end
    else if (EN) begin
        Q <= D;
    end
end

endmodule