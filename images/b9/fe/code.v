module top_module(
  input [n-1:0] ctrl,
  input clk,           // Added clock input
  input reset,        // Added reset input
  input load,         // Added load input
  output [m-1:0] cfg
);parameter n = 4; // number of control signals
parameter m = 8; // number of configuration signals

reg [m-1:0] config_reg; // register to store configuration settings

always @(posedge clk) begin
  if (reset) begin // synchronous reset
    config_reg <= 0;
  end else if (load) begin // load input
    config_reg <= ctrl;
  end
end

assign cfg = config_reg; // output configuration signals

endmodule