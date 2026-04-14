module mux_2to1(
    input sel,
    input [3:0] A,
    input [3:0] B,
    output reg [3:0] Y
);

always @(*) begin
    if (sel)
        Y = B;
    else
        Y = A;
end

endmodule