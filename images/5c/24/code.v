module up_counter_4
(
  input rst,
  input clk,

  output reg [3:0] count
);

  always @(posedge clk or posedge rst) begin
    if (rst) 
	begin
      count <= 4'b0000;
    end 
	else 
	begin
      if (count == 4'b1111) 
	  begin
        count <= 4'b0000;
      end 
	  else 
	  begin
        count <= count + 1;
      end
    end
  end

endmodule