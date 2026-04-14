module simple_calculator(
    input [1:0] op,
    input [7:0] num1,
    input [7:0] num2,
    output [7:0] result
);

wire [15:0] temp;

assign temp = {op, num1} * {op[0], num2};
assign result = (op == 2'b00) ? num1 + num2 :
                (op == 2'b01) ? num1 - num2 :
                (op == 2'b10) ? temp[15:8] :
                (op == 2'b11) ? (temp[15:8] == 8'h00) ? 8'h00 : temp[15:8] / num2 :
                                8'h00;

endmodule