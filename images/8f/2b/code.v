module barrel_shifter (
    input [15:0] data_in,
    input [3:0] shift_amount,
    input direction,
    output reg [15:0] data_out);always @(*) begin
        if (direction == 1'b0)
            data_out = data_in << shift_amount;
        else
            data_out = data_in >> shift_amount;
    end

endmodule