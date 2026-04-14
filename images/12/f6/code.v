module barrel_shifter (
    input [7:0] data,
    input [2:0] shift_amount,
    input direction, // 0 for left, 1 for right
    output reg [7:0] result
);

always @(*) begin
    if (direction == 0) begin // Left shift
        result = data << shift_amount;
    end else begin // Right shift
        result = data >> shift_amount;
    end
end

endmodule