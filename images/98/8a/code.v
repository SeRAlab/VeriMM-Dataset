module binary_counter_parallel_load_3
(
  input rst,
  input clk,
  input enable,
  input load,
  input [2:0] load_value,

  output reg [2:0] count
);

  always @(posedge clk or posedge rst) begin
    if (rst) 
	begin
      count <= 3'b000;
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