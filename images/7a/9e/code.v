module top_module(
    input [1:0] shift_amount,
    input direction,
    input signed [3:0] signed_data,
    output reg GTE
);reg signed [3:0] shifted_data;

always @(*) begin
    if (direction == 0) // shift left
        shifted_data = signed_data << shift_amount;
    else // shift right
        shifted_data = signed_data >> shift_amount;
end

always @(*) begin
    if (shifted_data >= 0)
        GTE = 1;
    else
        GTE = 0;
end

endmodule