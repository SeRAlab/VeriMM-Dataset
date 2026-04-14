module top_module(
  input clk,
  input rst,
  input en,
  input in,
  output reg out
);reg prev_out; // flip-flop to store previous value of out

  always @(posedge clk) begin
    if (rst) begin
      out <= 1'b0; // reset out to 0
      prev_out <= 1'b0; // reset prev_out to 0
    end
    else if (en) begin
      out <= in; // pass through input to output
      prev_out <= in; // update prev_out with new input
    end
    else begin
      out <= prev_out; // hold previous value of out
    end
  end

endmodule