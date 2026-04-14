module top_module(valid,
    ram_valid_i,
    clk,
    Q);output valid;
  input ram_valid_i;
  input clk;
  input [0:0]Q;

  reg [0:0] Q_reg;
  reg [0:0] ram_valid_d1_reg;
  wire [0:0] Q;
  wire clk;
  wire ram_valid_i;
  wire valid;

  always @(posedge clk) begin
    Q_reg <= Q;
    ram_valid_d1_reg <= ram_valid_i;
  end

  assign valid = (Q_reg && ram_valid_d1_reg);

endmodule