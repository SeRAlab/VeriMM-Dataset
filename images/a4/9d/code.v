module top_module(
    input [31:0] data,
    input [4:0] shift_amount,
    input shift_direction,
    output [31:0] shifted_output
);reg [31:0] shifted_data;

always @(*) begin
    if (shift_direction == 0) // Left shift
        shifted_data = data << shift_amount;
    else // Right shift
        shifted_data = data >> shift_amount;
end

assign shifted_output = shifted_data;

endmodule