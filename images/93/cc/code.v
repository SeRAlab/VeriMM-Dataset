module shift_register_4bit 
(
  input rst_n,
  input clk,
  input shift_enable,

  output reg [3:0] out
);

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) 
	begin
      out <= 4'b0000;
    end 

	else if (shift_enable) 
	begin
      out <= out << 1;
    end 
	
	else begin
      out <= out; // Hold the current value when shift_enable is inactive
    end
  end

endmodule