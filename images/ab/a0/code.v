module top_module(clk_ref_i,
    aclk,
    sys_clk_i,
    resetn,
    clk_in1);output clk_ref_i;
  output aclk;
  output sys_clk_i;
  input resetn;
  input clk_in1;

  wire aclk;
  (* IBUF_LOW_PWR *) wire clk_in1;
  wire clk_ref_i;
  wire resetn;
  wire sys_clk_i;

  reg [1:0] counter = 0;
  reg clk_ref_i_reg = 0;
  reg aclk_reg = 0;
  reg sys_clk_i_reg = 0;

  always @(posedge clk_in1 or negedge resetn) begin
    if (~resetn) begin
      counter <= 0;
      clk_ref_i_reg <= 0;
      aclk_reg <= 0;
      sys_clk_i_reg <= 0;
    end else begin
      counter <= counter + 1;
      if (counter == 1) begin
        clk_ref_i_reg <= ~clk_ref_i_reg;
      end
      if (counter == 3) begin
        aclk_reg <= ~aclk_reg;
        counter <= 0;
      end
      if (counter == 7) begin
        sys_clk_i_reg <= ~sys_clk_i_reg;
        counter <= 0;
      end
    end
  end

  assign clk_ref_i = clk_ref_i_reg;
  assign aclk = aclk_reg;
  assign sys_clk_i = sys_clk_i_reg;

endmodule