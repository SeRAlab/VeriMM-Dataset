module sync_up_down_counter_4bit 
(
  input reset,
  input clk,
  input up_down,

  output reg [3:0] count
);

  always @(posedge clk or posedge reset) begin
    if (reset) 
	begin
      count <= 4'b0000;
    end 
	
	else if (up_down) 
	begin
      if (count == 4'd15) 
	  begin
        count <= 4'b0000;
      end 
	  else begin
        count <= count + 1;
      end
    end 
	
	else 
	begin
      if (count == 4'd0) 
	  begin
        count <= 4'd15;
      end 
	  else begin
        count <= count - 1;
      end
    end
  end

endmodule