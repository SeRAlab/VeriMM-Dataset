module top_module(
  input clk,
  input reset,
  input load,
  input [3:0] data_in,
  output reg [3:0] data_out
);always @(posedge clk, negedge reset)
  begin
    if (~reset) // reset to all zeros
      data_out <= 4'b0;
    else if (load) // parallel load
      data_out <= data_in;
    else // shift left
      data_out <= {data_out[2:0], data_in};
  end

endmodule