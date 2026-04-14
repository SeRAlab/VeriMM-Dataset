module up_down_counter 
(
  input rst_n,
  input clk,
  input en,
  input dir,

  output reg [3:0] out
);

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) 
	begin
      out <= 4'b0000;
    end 
	
	else if (en) 
	begin
      if (dir) 
	  begin
        if (out == 4'b1111) 
		begin
          out <= 4'b0000;
        end 
		else 
		begin
          out <= out + 1;
        end
      end 
	  else 
	  begin
        if (out == 4'b0000) 
		begin
          out <= 4'b1111;
        end 
		else 
		begin
          out <= out - 1;
        end
      end
    end 
	
	else 
	begin
      out <= out; // Pause the count when en is invalid
    end
  end

endmodule