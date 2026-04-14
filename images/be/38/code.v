module top_module(
  input [15:0] num,
  output reg is_power_of_2
);always @(*) begin
    if (num == 0) // Special case for 0
      is_power_of_2 = 0;
    else
      is_power_of_2 = ((num & (num - 1)) == 0) ? 1 : 0; // Check if only one bit is set
  end
  
endmodule