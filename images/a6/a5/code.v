module binary_counter_load_7
(
  input rst,
  input clk,
  input enable,
  input load,
  input [6:0] load_value,

  output reg [6:0] count
);

  always @(posedge clk or posedge rst) begin
    if (rst) 
	begin
      count <= 7'b0000000;
    end 
	
	else if (load) 
	begin
      count <= load_value;
    end 
	
	else if (enable) 
	begin
      count <= count + 1;
    end
  end

endmodule