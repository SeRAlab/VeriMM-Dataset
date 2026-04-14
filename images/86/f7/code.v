module top_module(
  input                clk,
  input                rst_n,
  output reg  [3:0]    Q
);reg [63:0] shift_reg;
  reg [3:0]  next_state;

  always @(posedge clk) begin
    if (!rst_n) begin
      shift_reg <= 64'b0;
      Q <= 4'b0;
      next_state <= 4'b0001;
    end
    else begin
      shift_reg <= {shift_reg[62:0], shift_reg[63] ^ shift_reg[60]};
      Q <= shift_reg[63:60];
      next_state <= {next_state[2:0], next_state[3] ^ next_state[0]};
    end
  end

  always @(posedge clk) begin
    if (!rst_n) begin
      Q <= 4'b0;
    end
    else begin
      Q <= next_state;
    end
  end

endmodule