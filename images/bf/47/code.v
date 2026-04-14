module top_module(
  input clk, // clock input
  input ena, // enable input
  input dclr, // clear input
  input [7:0] coef, // coefficient input
  input [7:0] din, // data input
  output reg [23:0] result // output
);// define widths
  localparam cwidth = 8; // coefficient width
  localparam dwidth = 8; // data width
  localparam mwidth = cwidth + dwidth; // multiplier width
  localparam rwidth = mwidth + 3; // result width

  // define signals
  reg [mwidth-1:0] mult_res; // multiplier output
  reg [rwidth-1:0] ext_mult_res; // multiplier output extended
  reg [rwidth-1:0] ext_result; // result output extended

  // pad inputs with zeros
  assign icoef = { {(mwidth-cwidth){coef[cwidth-1]}}, coef};
  assign idin  = { {(mwidth-dwidth){din[dwidth-1]}}, din};

  // generate multiplier structure
  always @(posedge clk)
    if(ena)
      mult_res <= #1 icoef * idin;

  // extend multiplier output
  assign ext_mult_res = { {3{mult_res[mwidth-1]}}, mult_res};

  // generate adder structure
  always @(posedge clk)
    if(ena)
      if(dclr)
        result <= #1 ext_mult_res;
      else
        result <= #1 ext_mult_res + ext_result;

  // extend result output
  assign ext_result = { {3{result[rwidth-1]}}, result};

endmodule