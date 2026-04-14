module register_8bit
(
  input rst_n,
  input clk,
  input ld,
  input [7:0] data_in,

  output reg [7:0] data_out
);

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) 
	begin
      data_out <= 8'b00000000;
    end
	
	else if (ld) 
	begin
      data_out <= data_in;
    end
	
	else 
	begin
      data_out <= data_out;
    end
  end

endmodule