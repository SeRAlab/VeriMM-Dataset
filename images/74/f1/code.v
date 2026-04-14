module ring_counter 
(
  input rst_n,
  input clk,

  output reg [3:0] q
);

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) 
	begin
      q <= 4'b0001;
    end 
	
	else 
	begin
      q <= {q[2:0], q[3]};
    end
  end

endmodule