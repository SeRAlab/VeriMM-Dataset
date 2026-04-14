module down_counter 
(
  input rst_n,
  input clk,
  input en,

  output reg [3:0] count
);

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) 
	begin
      count <= 4'b1111;
    end 
	
	else if (en) 
	begin
      if (count == 4'd0) 
	  begin
        count <= 4'b1111;
      end 
	  else begin
        count <= count - 1;
      end
    end 
	
	else begin
      count <= count; // Pause the count when enable is low
    end
  end

endmodule