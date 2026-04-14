module barrel_shifter (
    input [7:0] data_in,
    input [3:0] shift_amount,
    output reg [7:0] data_out
);
    always @(*) begin
        case (shift_amount)
            4'b0000: data_out = data_in; // No shift
            4'b0001: data_out = data_in << 1; // Shift left by 1
            4'b0010: data_out = data_in << 2; // Shift left by 2
            4'b0011: data_out = data_in << 3; // Shift left by 3
            4'b0100: data_out = data_in >> 1; // Shift right by 1
            4'b0101: data_out = data_in >> 2; // Shift right by 2
            4'b0110: data_out = data_in >> 3; // Shift right by 3
            4'b0111: data_out = data_in >> 4; // Shift right by 4
            default: data_out = 8'b00000000; // Default case (should not occur)
        endcase
    end
endmodule