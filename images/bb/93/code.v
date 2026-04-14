module ring_counter_4bit 
(
  input rst_n,
  input clk,
  input enable,

  output reg [3:0] out
);

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) 
	begin
      out <= 4'b0001;
    end 
	else if (enable) 
	begin
      out <= {out[2:0], out[3]};
    end 
	else 
	begin
      out <= out; // Hold the current value when enable is inactive
    end
  end

endmodule