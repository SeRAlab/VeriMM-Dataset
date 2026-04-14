module top_module(
    input [15:0] data_in,
    input [3:0] shift_amount,
    input shift_direction,
    output [15:0] data_out
);reg [15:0] shifted_data;

always @(*) begin
    if (shift_direction == 1'b0) // right shift
        shifted_data = data_in >> shift_amount;
    else // left shift
        shifted_data = data_in << shift_amount;
end

assign data_out = shifted_data;

endmodule