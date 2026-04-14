module johnson_counter 
(
  input rst_n,
  input clk,

  output reg [2:0] q
);

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) 
	begin
      q <= 3'b000;
    end 
	
	else 
	begin
      q <= {~q[0], q[2:1]};
    end
  end

endmodule