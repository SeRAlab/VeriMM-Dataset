module top_module(
  input signed [7:0] A,
  input signed [7:0] B,
  input [2:0] OP,
  input CLK,
  input RST,
  output reg signed [15:0] RES
);always @(posedge CLK) begin
    if (RST) begin
      RES <= 16'b0;
    end else begin
      case (OP)
        3'b000: RES <= A + B; // addition
        3'b001: RES <= A - B; // subtraction
        3'b010: RES <= A * B; // multiplication
        3'b011: RES <= A / B; // integer division
        default: RES <= 16'b0;
      endcase
    end
  end

endmodule