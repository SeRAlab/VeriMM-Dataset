module top_module(
  input clk,
  input rst_n,
  input [1:0] select,
  output reg [7:0] out
);reg [63:0] shift_reg;
  reg [1:0] mux_sel;

  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      shift_reg <= 64'h1;
      mux_sel <= 2'h0;
    end else begin
      shift_reg <= {shift_reg[62:0], shift_reg[0] ^ shift_reg[63]};
      mux_sel <= mux_sel + 1;
    end
  end

  always @(select) begin
    case (select)
      2'h0: out <= shift_reg[7:0];
      2'h1: out <= shift_reg[15:8];
      2'h2: out <= shift_reg[23:16];
      2'h3: out <= shift_reg[31:24];
    endcase
  end

  always @(mux_sel) begin
    case (mux_sel[1:0])
      2'h0: out <= shift_reg[7:0];
      2'h1: out <= shift_reg[15:8];
      2'h2: out <= shift_reg[23:16];
      2'h3: out <= shift_reg[31:24];
    endcase
  end

endmodule