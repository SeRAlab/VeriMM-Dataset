module top_module(input [15:0] in, input clock, load, inc, reset, output reg [15:0] out);wire [15:0] oInc, nextValue;
  wire loadInc, loadIncReset;

  // Combinational logic for load and increment signals
  assign loadInc = load | inc;      // OR gate for load and increment
  assign loadIncReset = loadInc | reset; // OR gate for loadInc and reset

  // 16-bit increment logic
  assign oInc = out + 1;            // Incrementing out by 1

  // MUX for choosing between inputs based on control signals
  assign nextValue = load ? in : (reset ? 16'b0 : (inc ? oInc : out));

  // 16-bit register with load behavior
  always @(posedge clock) begin
    if (loadIncReset) begin
      out <= nextValue; // Update out based on selected value
    end
  end

endmodule