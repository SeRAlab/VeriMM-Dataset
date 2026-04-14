module top_module(
    input [15:0] in_value,
    input [15:0] mask_value,
    input [3:0] shift_value,
    input [2:0] op_select,
    output [15:0] out_value
);reg [15:0] temp_value;

always @(*) begin
    case(op_select)
        3'b000: temp_value = in_value & mask_value;
        3'b001: temp_value = in_value | mask_value;
        3'b010: temp_value = in_value ^ mask_value;
        3'b011: temp_value = in_value << shift_value;
        3'b100: temp_value = in_value >> shift_value;
        default: temp_value = in_value;
    endcase
end

assign out_value = temp_value;

endmodule