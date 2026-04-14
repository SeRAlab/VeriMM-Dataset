module barrel_shifter (
    input [3:0] data_in,
    input [1:0] shift_amount,
    input shift_dir, // 0 for left shift, 1 for right shift
    output reg [3:0] data_out
);
    always @(*) begin
        case (shift_dir)
            0: // Left shift
                case (shift_amount)
                    2'b00: data_out = data_in;         // No shift
                    2'b01: data_out = data_in << 1;    // Shift left by 1
                    2'b10: data_out = data_in << 2;    // Shift left by 2
                    2'b11: data_out = data_in << 3;    // Shift left by 3
                    default: data_out = 4'b0000;
                endcase
            1: // Right shift
                case (shift_amount)
                    2'b00: data_out = data_in;         // No shift
                    2'b01: data_out = data_in >> 1;    // Shift right by 1
                    2'b10: data_out = data_in >> 2;    // Shift right by 2
                    2'b11: data_out = data_in >> 3;    // Shift right by 3
                    default: data_out = 4'b0000;
                endcase
        endcase
    end
endmodule