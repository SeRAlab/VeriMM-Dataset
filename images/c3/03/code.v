module arithmetic_right_shift (
    input [3:0] data_in,
    input [1:0] shift_amount,
    output reg [3:0] data_out
);

    always @(*) begin
        case (shift_amount)
            2'b00: data_out = data_in;
            2'b01: data_out = {data_in[3], data_in[3:1]};
            2'b10: data_out = {data_in[3:2], data_in[3:2]};
            2'b11: data_out = {data_in[3:3], data_in[3:2]};
        endcase
    end

endmodule