module top_module(
  input                clk,
  input                rst_n,
  output reg  [3:0]    Q
);reg [63:0] shift_reg;
  wire [63:0] xor_output;

  assign xor_output = shift_reg ^ ({shift_reg[0], shift_reg[63:1]});

  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      shift_reg <= 64'h0000000000000000;
      Q <= 4'b0000;
    end
    else begin
      shift_reg <= {shift_reg[62:0], xor_output[0]};
      Q <= {shift_reg[1], shift_reg[0]};
    end
  end

endmodule