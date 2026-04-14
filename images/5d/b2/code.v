module top_module(clk,
    rst,
    load,
    D,
    Q);input clk;
  input rst;
  input load;
  input [0:0]D;
  output reg [0:0]Q; // Declare Q as a reg type

  // Internal signals
  wire mux_out;

  // 2-input LUT equivalent
  assign mux_out = load ? D : Q; // Update Q based on load signal

  always @(posedge clk or posedge rst) begin
    if (rst)
      Q <= 1'b0; // Reset Q to 0
    else
      Q <= mux_out; // Load D or retain Q
  end
endmodule