module top_module(D,
    Q,
    m_aclk,
    rd_rst_reg_reg);output reg [3:0] Q;
  input [3:0] D;
  input m_aclk;
  input rd_rst_reg_reg;

  // Synchronous process for flip-flops
  always @(posedge m_aclk or posedge rd_rst_reg_reg) begin
    if (rd_rst_reg_reg)
      Q <= 4'b0000;  // Reset output to 0
    else
      Q <= D;       // Transfer input D to output Q
  end
endmodule