module binary_counter_enable_5 
(
  input rst,
  input clk,
  input enable,

  output reg [4:0] count
);

  always @(posedge clk or posedge rst) begin
    if (rst) 
	begin
      count <= 5'b00000;
    end 
	
	else if (enable) 
	begin
      count <= count + 2;
    end
  end

endmodule