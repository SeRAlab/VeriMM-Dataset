module binary_counter_preset_6
(
  input rst,
  input clk,
  input enable,
  input preset,
  input [5:0] preset_value,

  output reg [5:0] count
);

  always @(posedge clk or posedge rst) begin
    if (rst) 
	begin
      count <= 6'b000000;
    end 
	
	else if (preset) 
	begin
      count <= preset_value;
    end 
	
	else if (enable) 
	begin
      count <= count + 1;
    end
  end

endmodule