module top_module(a,
    d,
    dpra,
    clk,
    we,
    i_ce,
    qspo_ce,
    qdpo_ce,
    qdpo_clk,
    qspo_rst,
    qdpo_rst,
    qspo_srst,
    qdpo_srst,
    spo,
    dpo,
    qspo,
    qdpo);input [9:0] a;
  input [15:0] d;
  input [9:0] dpra;
  input clk;
  input we;
  input i_ce;
  input qspo_ce;
  input qdpo_ce;
  input qdpo_clk;
  input qspo_rst;
  input qdpo_rst;
  input qspo_srst;
  input qdpo_srst;
  
  output [15:0] spo;
  output [15:0] dpo;
  output [15:0] qspo;
  output [15:0] qdpo;

  reg [15:0] stack [0:1023];
  reg [9:0] sp;
  reg [15:0] data_out; // Change wire to reg to fix the L-value issue

  // Push data onto the stack
  always @(posedge clk) begin
    if (i_ce && we) begin
      stack[sp] <= d;
      sp <= sp + 1;
    end
  end

  // Pop data off the stack
  always @(posedge qdpo_clk) begin
    if (qdpo_ce) begin
      if (qdpo_rst) begin
        sp <= 0;
      end else begin
        sp <= sp - 1;
      end
    end
  end

  // Read data from the stack
  always @(*) begin
    data_out = stack[a];
  end

  // Assign outputs
  assign spo = data_out;
  assign dpo = data_out;
  assign qspo = stack[sp];
  assign qdpo = stack[sp-1];

endmodule