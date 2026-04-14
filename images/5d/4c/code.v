module barrel_shifter(
    input [7:0] data,
    input [2:0] shift_amount,
    input shift_right,
    output reg [7:0] shifted_data);always @(*) begin
    if (shift_right)
        shifted_data = data >> shift_amount;
    else
        shifted_data = data << shift_amount;
end
endmodule