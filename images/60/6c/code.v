module top_module(clk_in, rst, go, enable, last_clk, divider, clk_out, pos_edge, neg_edge);parameter Tp = 1;
  
  input                            clk_in;   
  input                            rst;      
  input                            enable;   
  input                            go;       
  input                            last_clk; 
  input      divider;  
  output                           clk_out;  
  output                           pos_edge; 
  output                           neg_edge; 
                            
  reg                              clk_out;
  reg                              pos_edge;
  reg                              neg_edge;
                            
  reg        cnt;      
  wire                             cnt_zero; 
  wire                             cnt_one;  
  
  
  assign cnt_zero = cnt == {1{1'b0}};
  assign cnt_one  = cnt == {{0{1'b0}}, 1'b1};
  
  
  always @(posedge clk_in or posedge rst)
  begin
    if(rst)
      cnt <= #Tp {1{1'b1}};
    else
      begin
        if(!enable || cnt_zero)
          cnt <= #Tp divider;
        else
          cnt <= #Tp cnt - {{0{1'b0}}, 1'b1};
      end
  end
  
  
  always @(posedge clk_in or posedge rst)
  begin
    if(rst)
      clk_out <= #Tp 1'b0;
    else
      clk_out <= #Tp (enable && cnt_zero && (!last_clk || clk_out)) ? ~clk_out : clk_out;
  end
   
  
  always @(posedge clk_in or posedge rst)
  begin
    if(rst)
      begin
        pos_edge  <= #Tp 1'b0;
        neg_edge  <= #Tp 1'b0;
      end
    else
      begin
        pos_edge  <= #Tp (enable && !clk_out && cnt_one) || (!(|divider) && clk_out) || (!(|divider) && go && !enable);
        neg_edge  <= #Tp (enable && clk_out && cnt_one) || (!(|divider) && !clk_out && enable);
      end
  end
endmodule