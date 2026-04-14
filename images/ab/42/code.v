module top_module(
    output reg [45:0] Q_reg,
    input [22:0] D,
    input [0:0] Q,
    input CLK,
    input [0:0] AR,
    input Overflow_flag_A
);reg [45:0] Q_reg_next;

  // Implement multiplication using a series of shifts and adds
  wire [45:0] product;
  assign product = {23'b0, D} << Q;

  // Implement overflow detection
  wire overflow;
  assign overflow = product[45] ^ Overflow_flag_A;

  // Implement synchronous reset
  always @(posedge CLK) begin
    if (AR) begin
      Q_reg <= 0;
    end else begin
      Q_reg <= Q_reg_next;
    end
  end

  // Implement combinational logic
  always @(*) begin
    if (overflow) begin
      Q_reg_next[45] = 1;
      Q_reg_next[44:0] = 0;
    end else begin
      Q_reg_next = product;
    end
  end

endmodule