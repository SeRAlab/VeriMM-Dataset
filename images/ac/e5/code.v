module ring_counter_10 
(
  input rst,
  input clk,

  output reg [9:0] count
);

  always @(posedge clk or posedge rst) begin
    if (rst) 
	begin
      count <= 10'b0000000001;
    end 
	
	else 
	begin
      count <= {count[8:0], count[9]};
    end
  end

endmodule