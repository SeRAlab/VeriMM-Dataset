module top_module(
                                        
                                         clk,
                                         clkx2,
                                         jrst_n,
                                         tw,

                                        
                                         tr_clk,
                                         tr_data
                                      )
;output           tr_clk;
  output  [ 17: 0] tr_data;
  input            clk;
  input            clkx2;
  input            jrst_n;
  input   [ 35: 0] tw;

  wire             phase;
  wire             tr_clk;
  reg              tr_clk_reg ;
  wire    [ 17: 0] tr_data;
  reg     [ 17: 0] tr_data_reg ;
  reg              x1 ;
  reg              x2 ;
  assign phase = x1^x2;
  always @(posedge clk or negedge jrst_n)
    begin
      if (jrst_n == 0)
          x1 <= 0;
      else 
        x1 <= ~x1;
    end


  always @(posedge clkx2 or negedge jrst_n)
    begin
      if (jrst_n == 0)
        begin
          x2 <= 0;
          tr_clk_reg <= 0;
          tr_data_reg <= 0;
        end
      else 
        begin
          x2 <= x1;
          tr_clk_reg <= ~phase;
          tr_data_reg <= phase ?   tw[17 : 0] :   tw[35 : 18];
        end
    end


  assign tr_clk = 0 ? tr_clk_reg : 0;
  assign tr_data = 0 ? tr_data_reg : 0;

endmodule