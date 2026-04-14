module binary_counter_4 
(
  input rst,
  input clk,
  input load,
  input [3:0] load_value,

  output reg [3:0] count
);

  always @(posedge clk or posedge rst) begin
    if (rst) 
	begin
      count <= 4'b0000;
    end 
	
	else if (load) 
	begin
      count <= load_value;
    end 
	
	else 
	begin
      count <= count + 1;
    end
  end

endmodule