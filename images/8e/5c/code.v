module top_module(
  input [3:0] A,
  input [3:0] B,
  input Sub,
  input clk,
  output reg [3:0] result  // Change wire to reg for result
);wire [3:0] add_result;
  wire [3:0] sub_result;

  // Adder logic
  assign add_result = A + B;

  // Subtractor logic
  assign sub_result = A - B;

  // Result selection logic
  always @ (posedge clk) begin
    if (Sub == 1'b0) begin
      result <= add_result;
    end else begin
      result <= sub_result;
    end
  end

endmodule