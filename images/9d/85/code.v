module ring_counter_5 
(
  input rst,
  input clk,

  output reg [4:0] count
);

  always @(posedge clk or posedge rst) begin
    if (rst) 
	begin
      count <= 5'b00001;
    end 
	else 
	begin
      count <= {count[3:0], count[4]};
    end
  end

endmodule