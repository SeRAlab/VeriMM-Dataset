module dragonball_wbmaster(
  clk, reset_n,
  a, cs_n, d, lwe_n, uwe_n, oe_n, dtack_n, berr,
  clk_o, rst_o, cyc_o, stb_o, adr_o, sel_o, we_o, dat_o, dat_i, ack_i, err_i
);
  parameter adr_hi = 9;
  input             clk;           
  input             reset_n;       
  input  [adr_hi:1] a;             
  input             cs_n;          
  inout  [    15:0] d;             
  input             lwe_n, uwe_n;  
  input             oe_n;          
  output            dtack_n;       
  output            berr;          
  output            clk_o;         
  output            rst_o;         
  output            cyc_o;         
  output            stb_o;         
  output [adr_hi:1] adr_o;         
  output [     1:0] sel_o;         
  output            we_o;          
  output [    15:0] dat_o;         
  input  [    15:0] dat_i;         
  input             ack_i;         
  input             err_i;         
  reg            cyc_o, stb_o;
  reg [adr_hi:1] adr_o;
  reg [     1:0] sel_o;
  reg            we_o;
  reg            dtack;
  reg [    15:0] sdat_i;
  wire cs  = !cs_n & !(ack_i | err_i | dtack);   
  wire lwe = !lwe_n;                             
  wire uwe = !uwe_n;                             
  wire oe  = !oe_n;                              
  assign clk_o = clk;                            
  assign rst_o = reset_n;                        
  assign berr = err_i;
  always @(posedge clk or negedge reset_n)
    if (!reset_n)
      begin
          cyc_o  <= #1 1'b0;
          stb_o  <= #1 1'b0;
          adr_o  <= #1 {{adr_hi-1}{1'b0}};
          sel_o  <= #1 2'b00;
          we_o   <= #1 1'b0;
          dtack  <= #1 1'b0;
          sdat_i <= #1 16'h0;
      end
    else
      begin
          cyc_o  <= #1 cs;                       
          stb_o  <= #1 cs;                       
          adr_o  <= #1 a;                        
          sel_o  <= #1 oe ? 2'b11 : {uwe, lwe};  
          we_o   <= #1 uwe | lwe;                
          dtack  <= #1 ack_i & !dtack;           
          sdat_i <= #1 dat_i;                    
      end
  assign dat_o   = d;                            
  assign d       = (~cs_n & oe) ? sdat_i : 16'hzzzz; 
  assign dtack_n = !dtack;                       
endmodule