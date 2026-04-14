module sync_down_counter_5
(
  input rst,
  input clk,

  output reg [4:0] count
);

  always @(posedge clk or posedge rst) begin
    if (rst) 
	begin
      count <= 5'b11111;
    end 
	else 
	begin
      if (count == 5'b00000) 
	  begin
        count <= 5'b11111;
      end 
	  else 
	  begin
        count <= count - 1;
      end
    end
  end

endmodule