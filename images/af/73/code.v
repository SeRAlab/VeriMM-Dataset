module ring_counter_enable_10 
(
  input rst,
  input clk,
  input enable,

  output reg [9:0] count
);

  always @(posedge clk or posedge rst) begin
    if (rst) 
	begin
      count <= 10'b0000000001;
    end 
	
	else if (enable) 
	begin
      count <= {count[8:0], count[9]};
    end
  end

endmodule