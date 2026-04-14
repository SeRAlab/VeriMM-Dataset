module barrel_shifter (
    input [3:0] data_in,
    input [1:0] shift_amount,
    input direction, // 0 for left shift, 1 for right shift
    output reg [3:0] data_out
);

always @(*) begin
    case (direction)
        1'b0: // left shift
            case (shift_amount)
                2'b00: data_out = data_in;
                2'b01: data_out = {data_in[2:0], 1'b0};
                2'b10: data_out = {data_in[1:0], 2'b00};
                2'b11: data_out = {data_in[0], 3'b000};
                default: data_out = 4'b0000; // default case
            endcase
        1'b1: // right shift
            case (shift_amount)
                2'b00: data_out = data_in;
                2'b01: data_out = {1'b0, data_in[3:1]};
                2'b10: data_out = {2'b00, data_in[3:2]};
                2'b11: data_out = {3'b000, data_in[3]};
                default: data_out = 4'b0000; // default case
            endcase
    endcase
end

endmodule