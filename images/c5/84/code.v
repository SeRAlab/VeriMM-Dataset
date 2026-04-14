module adder_8bit_valid(
    input [7:0] A,
    input [7:0] B,
    input Valid_add,
    output reg [8:0] Sum
);

always @ (A, B, Valid_add) begin
    if (Valid_add) begin
        Sum = A + B;
    end
end

endmodule