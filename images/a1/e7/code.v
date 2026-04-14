module up_counter_12_with_load
(
  input rst,
  input clk,
  input enable,
  input load,
  input [11:0] data,

  output reg [11:0] count
);

  always @(posedge clk or posedge rst) begin
    if (rst) 
	begin
      count <= 12'b000000000000;
    end 
	
	else if (load) 
	begin
      count <= data;
    end 
	
	else if (enable) 
	begin
      count <= count + 1;
    end
  end

endmodule