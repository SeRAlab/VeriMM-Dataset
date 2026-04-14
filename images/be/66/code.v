module top_module(
  input [17:0] A,
  input [17:0] B,
  input [17:0] C,
  input CLK,
  input CEA,
  input RSTA,
  input CEB,
  input RSTB,
  input CEC,
  input RSTC,
  input SIGNEDA,
  input SIGNEDB,
  input SIGNEDC,
  input RSTOUT,
  input CEOUT,
  output [35:0] Z
);reg [35:0] Z_reg; // Register for output Z
  reg [17:0] A_reg, B_reg, C_reg; // Registers for inputs A, B, and C
  reg [35:0] temp; // Temporary register for intermediate values
  reg signed [35:0] A_signed, B_signed, C_signed; // Signed versions of inputs A, B, and C

  always @(posedge CLK) begin
    if (RSTA == 1'b1) A_reg <= 18'b0; // Reset input A
    else if (CEA == 1'b1) A_reg <= A; // Update input A
    if (RSTB == 1'b1) B_reg <= 18'b0; // Reset input B
    else if (CEB == 1'b1) B_reg <= B; // Update input B
    if (RSTC == 1'b1) C_reg <= 18'b0; // Reset input C
    else if (CEC == 1'b1) C_reg <= C; // Update input C
    if (RSTOUT == 1'b1) Z_reg <= 36'b0; // Reset output Z
    else if (CEOUT == 1'b1) Z_reg <= Z; // Update output Z

    // Convert inputs to signed if necessary
    if (SIGNEDA == 1'b1) A_signed <= $signed(A_reg);
    else A_signed <= A_reg;
    if (SIGNEDB == 1'b1) B_signed <= $signed(B_reg);
    else B_signed <= B_reg;
    if (SIGNEDC == 1'b1) C_signed <= $signed(C_reg);
    else C_signed <= C_reg;

    // Perform multiplication and addition operations
    temp <= A_signed * B_signed;
    temp <= temp + C_signed;

    // Update output Z
    Z_reg <= temp;
  end

  assign Z = Z_reg;

endmodule