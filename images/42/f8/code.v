module johnson_counter 
(
  input rst_n,
  input clk,
  input en,

  output reg [3:0] out
);

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) 
	begin
      out <= 4'b0000;
    end 
	
	else if (en) 
	begin
      out <= {out[2:0], ~out[3]}; // Shift left and feed inverted MSB into LSB
    end 
	
	else 
	begin
      out <= out; // Pause the count when en is invalid
    end
  end

endmodule