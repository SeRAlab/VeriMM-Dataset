module top_module(
    input [1:0] logic_op_x,
    input [31:0] operand_0_x,
    input [31:0] operand_1_x,
    output [31:0] logic_result_x
);reg [31:0] temp_result;

always @*
begin
    case (logic_op_x)
        2'b00: temp_result = operand_0_x & operand_1_x;
        2'b01: temp_result = operand_0_x | operand_1_x;
        2'b10: temp_result = operand_0_x ^ operand_1_x;
        default: temp_result = 0;
    endcase
end

assign logic_result_x = temp_result;

endmodule