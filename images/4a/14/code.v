module barrel_shifter_8bit (
    input clk,
    input [2:0] shift_amount,
    input shift_left,
    input [7:0] data_in,
    output reg [7:0] data_out);

always @(posedge clk) begin
    if (shift_left)
        data_out <= data_in << shift_amount;
    else
        data_out <= data_in >> shift_amount;
    end
    
endmodule