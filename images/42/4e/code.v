module down_counter_12_ld
(
  input rst,
  input clk,
  input ld,
  input [11:0] load_value,

  output reg [11:0] count
);

  always @(posedge clk or posedge rst) begin
    if (rst) 
	begin
      count <= 12'b111111111111;
    end 
	else if (ld)
	begin
      count <= load_value;
    end 
	else 
	begin
      if (count == 12'b000000000000) 
	  begin
        count <= 12'b111111111111;
      end 
	  else 
	  begin
        count <= count - 1;
      end
    end
  end

endmodule