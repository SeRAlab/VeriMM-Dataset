module binary_counter_4 
(
  input rst,
  input clk,
  input en,

  output reg [3:0] count
);

  always @(posedge clk or posedge rst) begin
    if (rst) 
	begin
      count <= 4'b0000;
    end 
	else if (en) 
	begin
      count <= count + 1;
    end 
	else 
	begin
      count <= count; // Hold the count when enable is low
    end
  end

endmodule