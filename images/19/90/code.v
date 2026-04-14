module barrel_shifter (
    input [3:0] in,
    input [1:0] shift_amount,
    input direction, // 0 for left shift, 1 for right shift
    output reg [3:0] out
);
    always @(*) begin
        case (direction)
            1'b0: // Left shift
                case (shift_amount)
                    2'b00: out = in;
                    2'b01: out = {in[2:0], 1'b0};
                    2'b10: out = {in[1:0], 2'b00};
                    2'b11: out = {in[0], 3'b000};
                    default: out = 4'b0000; // Should not happen
                endcase
            1'b1: // Right shift
                case (shift_amount)
                    2'b00: out = in;
                    2'b01: out = {1'b0, in[3:1]};
                    2'b10: out = {2'b00, in[3:2]};
                    2'b11: out = {3'b000, in[3]};
                    default: out = 4'b0000; // Should not happen
                endcase
        endcase
    end
endmodule