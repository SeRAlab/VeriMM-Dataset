module verified_johnson_counter 
(
  input rst_n,
  input clk,

  output reg [3:0] count
);

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) 
	begin
      count <= 4'b0000;
    end 

	else 
	begin
      count <= {~count[0], count[3:1]};
    end
  end

endmodule