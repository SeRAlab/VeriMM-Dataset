module edge_detector
(
  input clk,
  input rst_n,
  input signal_in,
  output reg edge_detected
);

  reg prev_signal_in;

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) 
	begin
      prev_signal_in <= 1'b0;
      edge_detected <= 1'b0;
    end 
	else 
	begin
      edge_detected <= (signal_in & ~prev_signal_in);
      prev_signal_in <= signal_in;
    end
  end

endmodule