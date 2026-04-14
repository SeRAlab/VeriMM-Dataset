module barrel_shifter (
    input [3:0] data_in,
    input [1:0] shift_amt,
    input dir, // 0 for left shift, 1 for right shift
    output reg [3:0] data_out
);
    always @(*) begin
        case (dir)
            0: // Left shift
                case (shift_amt)
                    2'b00: data_out = data_in;
                    2'b01: data_out = {data_in[2:0], 1'b0};
                    2'b10: data_out = {data_in[1:0], 2'b00};
                    2'b11: data_out = {data_in[0], 3'b000};
                endcase
            1: // Right shift
                case (shift_amt)
                    2'b00: data_out = data_in;
                    2'b01: data_out = {1'b0, data_in[3:1]};
                    2'b10: data_out = {2'b00, data_in[3:2]};
                    2'b11: data_out = {3'b000, data_in[3]};
                endcase
        endcase
    end
endmodule