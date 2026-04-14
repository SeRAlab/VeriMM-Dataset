module shift_register
(
  input rst_n,
  input clk,
  input shift_in,

  output reg [11:0] out
);

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) 
	begin
      out <= 12'd0;
    end 
	else 
	begin
      out <= {out[10:0], shift_in};
    end
  end

endmodule