module modulo_5_counter 
(
  input rst_n,
  input clk,
  input enable,

  output reg [2:0] out
);

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) 
	begin
      out <= 3'b000;
    end 
	else if (enable) 
	begin
      if (out == 3'b100) 
	  begin
        out <= 3'b000;
      end 
	  else 
	  begin
        out <= out + 1;
      end
    end 
	else 
	begin
      out <= out; // Hold the current value when enable is inactive
    end
  end

endmodule