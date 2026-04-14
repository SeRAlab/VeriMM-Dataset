module calculator(
    input [7:0] a,
    input [7:0] b,
    input [1:0] op,
    output [7:0] result,
    output overflow
);

reg [15:0] temp_result;

always @(*) begin
    case(op)
        2'b00: temp_result = a + b;
        2'b01: temp_result = a - b;
        2'b10: temp_result = a * b;
        2'b11: temp_result = a / b;
    endcase
end

assign result = temp_result[7:0];
assign overflow = (op[1] == 0) ? (temp_result > 8'hFF) : (temp_result > 16'hFFFF);

endmodule