module barrel_shifter(
    input clk,
    input reset,
    input [3:0] shift_amount,
    input [15:0] data_in,
    output reg [15:0] data_out);always @(posedge clk) begin
    if (reset)
        data_out <= 16'b0;
    else
        data_out <= data_in << shift_amount;
end
endmodule