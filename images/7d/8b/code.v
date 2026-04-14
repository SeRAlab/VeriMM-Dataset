module binary_down_counter
(
  input rst_n,
  input clk,
  input en,

  output reg [3:0] out
);

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) 
	begin
      out <= 4'b1111;
    end
	
	else if (en)
	begin
      out <= out - 1;
    end
	
	else 
	begin
      out <= out;
    end
  end

endmodule