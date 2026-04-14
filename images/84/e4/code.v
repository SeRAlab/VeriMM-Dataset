module binary_counter_4 
(
  input clk,
  input rst,
  input enable,

  output reg [3:0] count
);

  always @(posedge clk or posedge rst) begin
    if (rst) 
	begin
      count <= 4'b0000;
    end 
	
	else if (enable) 
	begin
      count <= count + 1;
    end
  end

endmodule