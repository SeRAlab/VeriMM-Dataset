module top_module(
  input            clk_dst,      
  input            rst_dst,      
  input            signal_src,   
  output reg       signal_dst    
);reg           signal_meta;     
                                 
                                 
                                 
                                 





  always @(posedge clk_dst)
  begin
    if (rst_dst)
    begin
      signal_meta <= 1'b0;
      signal_dst  <= 1'b0;
    end
    else 
    begin
      signal_meta <= signal_src;
      signal_dst  <= signal_meta;
    end 
  end 

endmodule