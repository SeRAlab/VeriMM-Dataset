module top_module(clk,   
                   rst,   
                   cs,   
                   init, 
                   bank, 
                   drun_rd, 
                   drun_wr, 
                   dlast,
                          
                   a,    
                   en,   
                   we,    
                   done);input        clk;
  input        rst;
  input        cs;
  input        init;
  input  [1:0] bank;
  input        drun_rd;
  input        drun_wr;
  input        dlast;
  output   [8:0] a;
  output       en;
  output       we;
  output       done;

   reg         we;
   reg         en;
   reg   [8:0]   a;
   reg         done;
   reg         cs_r;
   wire        sinit= cs && init;

   always @ (negedge clk) begin
     if (rst)       cs_r  <= 1'b0;
     else if (init) cs_r  <= cs;
     en <= cs_r && (drun_rd || drun_wr);
     we <= cs_r && drun_rd;
     done <= cs_r && dlast; 
     if (rst || sinit || done) a[6:0] <=7'b0;
     else if (en) a[6:0] <= a[6:0]+1;
     a[8:7]      <=  {~rst,~rst} & (sinit ? bank[1:0]: (a[8:7]+ done));
   end
endmodule