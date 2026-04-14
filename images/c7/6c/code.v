module mux4_1(
    output reg Y,
    input A,
    input B,
    input C,
    input D,
    input [1:0] S
);

always @(*) begin
    Y = (S == 2'b00) ? A :
        (S == 2'b01) ? B :
        (S == 2'b10) ? C :
        D;
end

endmodule