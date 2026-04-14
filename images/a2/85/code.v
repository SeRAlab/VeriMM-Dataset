module verified_binary_counter 
(
  input rst_n,
  input clk,

  output reg [2:0] count
);

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) 
	begin
      count <= 3'b000;
    end 

	else 
	begin
      if (count == 3'd5) 
	  begin
        count <= 3'b000;
      end 
	  else 
	  begin
        count <= count + 1;
      end
    end
  end

endmodule