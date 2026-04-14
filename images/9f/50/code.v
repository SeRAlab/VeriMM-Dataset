module shift_register 
(
  input rst_n,
  input clk,
  input shift_in,

  output reg [7:0] out
);

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) 
	begin
      out <= 8'b00000000;
    end 

	else 
	begin
      out <= {out[6:0], shift_in};
    end
  end

endmodule