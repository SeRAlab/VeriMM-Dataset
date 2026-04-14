module top_module(EN,
    D,
    CLK,
    Q_AND);output Q_AND;
  input EN;
  input [3:0] D;
  input CLK;

  reg [3:0] Q;  // Changed wire to reg
  wire Q_AND;

  // Implement a 4-bit register with synchronous clear
  always @(posedge CLK) begin
    if (EN) begin
      Q <= D;
    end else begin
      Q <= 4'b0;
    end
  end

  // Implement the logical AND of the register's four bits
  assign Q_AND = Q[0] & Q[1] & Q[2] & Q[3];

endmodule