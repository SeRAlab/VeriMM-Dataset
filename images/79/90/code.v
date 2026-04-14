module top_module(
  input [n-1:0] ctrl,
  input [m-1:0] data,
  input we,
  output [m-1:0] out
);parameter n = 4; // number of control signals
parameter m = 2; // number of data signals
parameter p = 3; // number of flip-flops

reg [n-1:0] flip_flops; // flip-flops to store control signals

assign out = data; // output signals are connected to data signals

always @ (posedge we) begin
  flip_flops <= ctrl; // write control signals to flip-flops
end

assign out = flip_flops & data; // AND the control signals with the data signals to get the output signals

endmodule