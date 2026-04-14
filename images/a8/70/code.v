module top_module(
  input clk,
  input rst,
  output [m-1:0] out
);parameter n = 4; // number of states
parameter m = 2; // number of output signals

reg [n-1:0] state;
reg [m-1:0] out_reg;

// Define the output signals as functions of the current state
always @ (state) begin
  case (state)
    0: out_reg = {1'b0, 1'b0};
    1: out_reg = {1'b0, 1'b1};
    2: out_reg = {1'b1, 1'b0};
    3: out_reg = {1'b1, 1'b1};
  endcase
end

// Define the state transitions
always @ (posedge clk, posedge rst) begin
  if (rst) begin
    state <= 0;
  end else begin
    case (state)
      0: state <= 1;
      1: state <= 2;
      2: state <= 3;
      3: state <= 0;
    endcase
  end
end

// Assign the output signals
assign out = out_reg;

endmodule