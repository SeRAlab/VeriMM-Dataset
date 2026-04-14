module barrel_shifter (
    input [3:0] data_in,
    input [1:0] shift_amount,
    input direction, // 0 for left shift, 1 for right shift
    output reg [3:0] data_out
);
  
    always @(*) begin
        case (direction)
            0: // Left Shift
                case (shift_amount)
                    2'b00: data_out = data_in;            // No shift
                    2'b01: data_out = {data_in[2:0], 1'b0}; // Shift left by 1
                    2'b10: data_out = {data_in[1:0], 2'b00}; // Shift left by 2
                    2'b11: data_out = 4'b0000;             // Shift left by 3
                endcase
            1: // Right Shift
                case (shift_amount)
                    2'b00: data_out = data_in;            // No shift
                    2'b01: data_out = {1'b0, data_in[3:1]}; // Shift right by 1
                    2'b10: data_out = {2'b00, data_in[3:2]}; // Shift right by 2
                    2'b11: data_out = 4'b0000;             // Shift right by 3
                endcase
            default: data_out = 4'b0000; // Default case
        endcase
    end
endmodule