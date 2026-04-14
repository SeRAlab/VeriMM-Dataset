module counter_enable_load_6 
(
  input rst,
  input clk,
  input enable,
  input load,
  input [5:0] preset_val,

  output reg [5:0] count
);

  always @(posedge clk or posedge rst) begin
    if (rst) 
	begin
      count <= 6'b000000;
    end 
	
	else if (load) 
	begin
      count <= preset_val;
    end 
	
	else if (enable) 
	begin
      count <= count + 1;
    end
  end

endmodule