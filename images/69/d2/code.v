module top_module(
                 l2clk,
                 se,
                 clksel,
                 bistclk,
                 lce,
                 l1clk
                 );input        l2clk;          
   input        se;             
   input        clksel;
   input        bistclk;
   input        lce;
   output       l1clk;

  assign l1clk = ((((l2clk & ~clksel)|(bistclk & clksel)) & ~lce) | se) ;endmodule