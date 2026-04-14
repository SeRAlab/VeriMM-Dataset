module adder(
    input [7:0] num1,
    input [7:0] num2,
    output reg [8:0] sum
);

always @(*) begin
    sum = num1 + num2;
end

endmodule