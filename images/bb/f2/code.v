module top_module(
  input clk,
  input reset,
  input [2:0] sel,
  input [3:0] data,
  output reg [3:0] Q
);reg [3:0] shift_reg;
  wire xor_out;

  always @(posedge clk) begin
    if (reset) begin
      shift_reg <= 4'b0000;
    end else begin
      shift_reg <= {shift_reg[2:0], xor_out};
    end
  end

  assign xor_out = shift_reg[3] ^ shift_reg[1];

  always @(*) begin
    case (sel)
      3'b000: Q = data[0];
      3'b001: Q = data[1];
      3'b010: Q = data[2];
      3'b011: Q = data[3];
      default: Q = 4'b0000;
    endcase
  end

endmodule