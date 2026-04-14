module up_down_counter 
(
  input rst_n,
  input clk,
  input up_down,

  output reg [7:0] out
);

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) 
	begin
      out <= 8'd128;
    end 

	else if (up_down) 
	begin
      if (out == 8'd255) 
	  begin
        out <= 8'd0;
      end 
	  else begin
        out <= out + 1;
      end
    end 
	
	else 
	begin
      if (out == 8'd0) 
	  begin
        out <= 8'd255;
      end 
	  else begin
        out <= out - 1;
      end
    end
  end

endmodule