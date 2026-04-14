module barrel_shifter (
    input [3:0] data_in,
    input [1:0] shift_amount,
    input direction, // 0 for left, 1 for right
    output reg [3:0] data_out
);
    
    always @(*) begin
        if (direction == 0) begin // left shift
            case (shift_amount)
                2'b00: data_out = data_in;           // no shift
                2'b01: data_out = data_in << 1;      // shift left by 1
                2'b10: data_out = data_in << 2;      // shift left by 2
                2'b11: data_out = data_in << 3;      // shift left by 3
                default: data_out = 4'b0000;         // should never occur
            endcase
        end else begin // right shift
            case (shift_amount)
                2'b00: data_out = data_in;           // no shift
                2'b01: data_out = data_in >> 1;      // shift right by 1
                2'b10: data_out = data_in >> 2;      // shift right by 2
                2'b11: data_out = data_in >> 3;      // shift right by 3
                default: data_out = 4'b0000;         // should never occur
            endcase
        end
    end
endmodule