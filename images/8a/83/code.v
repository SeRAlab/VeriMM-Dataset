module down_counter_10_with_preset
(
  input rst,
  input clk,
  input enable,
  input preset,
  input [9:0] preset_value,

  output reg [9:0] count
);

  always @(posedge clk or posedge rst) begin
    if (rst) 
	begin
      count <= 10'b0000000000;
    end 
	
	else if (preset) 
	begin
      count <= preset_value;
    end 
	
	else if (enable) 
	begin
      count <= count - 1;
    end
  end

endmodule