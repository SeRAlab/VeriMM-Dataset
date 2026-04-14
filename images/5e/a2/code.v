module down_counter_8
(
  input rst,
  input clk,

  output reg [7:0] count
);

  always @(posedge clk or posedge rst) begin
    if (rst) 
	begin
      count <= 8'b11111111;
    end 
	else 
	begin
      if (count == 8'b00000000) 
	  begin
        count <= 8'b11111111;
      end 
	  else 
	  begin
        count <= count - 1;
      end
    end
  end

endmodule