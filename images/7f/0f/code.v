module top_module (
  input clk,
  input reset,
  input load,
  input [7:0] data_in,
  output reg data_out);
  
reg [7:0] shift_reg;

always @(posedge clk or posedge reset) begin
    if (reset)
        shift_reg <= 8'b00000000;
    else if (load)
        shift_reg <= data_in;
    else
        shift_reg <= {shift_reg[6:0], 1'b0};
end

always @(shift_reg)
    data_out = shift_reg[7];
endmodule