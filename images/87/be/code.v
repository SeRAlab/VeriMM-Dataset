module johnson_counter_8 
(
  input rst,
  input clk,
  input enable,

  output reg [7:0] count
);

  always @(posedge clk or posedge rst) begin
    if (rst) 
	begin
      count <= 8'b00000000;
    end 
	
	else if (enable) 
	begin
      count <= {count[6:0], ~count[7]};
    end 
	
	else 
	begin
      count <= count; // Pause the count when enable is low
    end
  end

endmodule