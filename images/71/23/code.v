module top_module(input D, VPWR, VGND, VPB, VNB, CLK, output Q, Q_N);// Create a set/reset latch for Q and Q_N
  reg Q_SR, Q_N_SR;
  assign Q = Q_SR;
  assign Q_N = Q_N_SR;

  // Create a clocked SR latch for Q and Q_N
  reg Q_SR_CLK, Q_N_SR_CLK;
  always @(posedge CLK)
  begin
    Q_SR_CLK <= Q_SR;
    Q_N_SR_CLK <= Q_N_SR;
    Q_SR <= D;
    Q_N_SR <= D;
  end

  // Ensure that the outputs are initially x
  initial
  begin
    Q_SR = 1'bX;
    Q_N_SR = 1'bX;
  end
endmodule