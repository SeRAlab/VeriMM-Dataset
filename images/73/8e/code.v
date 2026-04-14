module loadable_counter 
(
  input rst_n,
  input clk,
  input en,
  input ld,
  input [3:0] load_value,

  output reg [3:0] out
);

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) 
	begin
      out <= 4'b0000;
    end 
	
	else if (ld) 
	begin
      out <= load_value;
    end 
	
	else if (en) 
	begin
      out <= out + 1;
    end 
	
	else 
	begin
      out <= out; // Pause the count when en and ld are invalid
    end
  end

endmodule