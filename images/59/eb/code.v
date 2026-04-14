module mux_2to1 (A, B, SEL, Y);
input [7:0] A, B;
input SEL;
output reg [7:0] Y;

always @(*) begin
    if (SEL)
        Y = B;
    else
        Y = A;
end

endmodule