module johnson_counter_3bit 
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
      out <= {~out[0], out[2:1]};
    end 
	else 
	begin
      out <= out; // Hold the current value when enable is inactive
    end
  end

endmodule