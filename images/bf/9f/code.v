module up_down_counter_8bit 
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
	
	else 
	begin
      if (up_down) 
	  begin
        if (count == 8'd255) 
		begin
          count <= 8'b00000000;
        end 
		
		else 
		begin
          count <= count + 1;
        end
      end 
	  
	  else 
	  begin
        if (count == 8'd0) 
		begin
          count <= 8'b11111111;
        end 
		
		else 
		begin
          count <= count - 1;
        end
      end
    end
  end

endmodule