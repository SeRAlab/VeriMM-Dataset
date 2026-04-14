module barrel_shifter (
    input [31:0] data_in,
    input [4:0] shift_amount,
    input direction, // 0 for left, 1 for right
    input enable,
    output reg [31:0] data_out
);
    always @(*) begin
        if (enable) begin
            if (direction == 0) begin // Left Shift
                data_out = data_in << shift_amount;
            end else begin // Right Shift
                data_out = data_in >> shift_amount;
            end
        end else begin
            data_out = data_in; // No shift
        end
    end
endmodule