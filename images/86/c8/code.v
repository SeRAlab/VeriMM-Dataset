module gray_code_counter_6bit 
(
  input rst_n,
  input clk,
  input enable,

  output reg [5:0] out
);

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) 
	begin
      out <= 6'b000000;
    end 
	else if (enable) 
	begin
      out <= {out[5], out[5:1] ^ out[4:0]};
    end 
	else 
	begin
      out <= out; // Hold the current value when enable is inactive
    end
  end

endmodule