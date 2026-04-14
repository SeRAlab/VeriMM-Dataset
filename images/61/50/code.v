module barrel_shifter(
    input clk,
    input reset,
    input [1:0] shift_amount,  // Shift amount
    input [3:0] data_in,
    output reg [3:0] data_out);always @(posedge clk) begin
    if (reset)
        data_out <= 4'b0000;
    else
        data_out <= (data_in >> shift_amount) | (data_in << (4 - shift_amount));
end
endmodule