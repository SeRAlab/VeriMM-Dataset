module verified_up_down_counter 
(
  input rst_n,
  input clk,
  input up_down,

  output reg [7:0] count
);

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) 
	begin
      count <= 8'b00000000;
    end 

	else if (up_down) 
	begin
      count <= count + 1;
    end 
	
	else 
	begin
      count <= count - 1;
    end
  end

endmodule