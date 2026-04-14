module verified_up_down_counter 
(
  input rst_n,
  input clk,
  input up_dn,

  output reg [3:0] count
);

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) 
	begin
      count <= 4'b0000;
    end 

	else 
	begin
      if (up_dn) 
	  begin
        count <= count + 1;
      end 
	  else 
	  begin
        count <= count - 1;
      end
    end
  end

endmodule