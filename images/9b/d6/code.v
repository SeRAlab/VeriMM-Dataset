module top_module(AS,
    out,
    s_axi_aclk,
    in0);output reg [0:0] AS;  // Declare AS as a reg type, since it will hold values
  input out;
  input s_axi_aclk;
  input [0:0] in0;

  reg Q_reg;  // Use a reg type for the flip-flop output

  always @(posedge s_axi_aclk) begin
    Q_reg <= out;  // Implementing FDRE functionality
  end

  always @(in0 or Q_reg) begin
    AS[0] = in0[0] & ~Q_reg;  // Implementing LUT2 functionality
  end
endmodule