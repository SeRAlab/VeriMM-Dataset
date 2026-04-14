module top_module(
  input clk,
  input rst,
  output reg [n-1:0] out
);parameter n = 4; // number of output signals

reg [n-1:0] state;
always @ (posedge clk) begin
  if (rst) begin
    state <= {n{1'b0}} | 1'b1; // reset to default state
  end else begin
    case (state)
      // define states as unique binary codes
      4'b0001: state <= 4'b0010;
      4'b0010: state <= 4'b0100;
      4'b0100: state <= 4'b1000;
      4'b1000: state <= 4'b0001;
      default: state <= {n{1'b0}} | 1'b1; // reset to default state if invalid state
    endcase
  end
end

// connect outputs to flip-flops based on current state
always @ (state) begin
  out = {n{1'b0}};
  out[state] = 1'b1;
end

endmodule