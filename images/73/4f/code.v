module top_module(
  input wire  clock_src,    
  output wire clock_lf,     
  output wire clock_hf      
  );reg [23:0] cnt;
  
  assign clock_lf = cnt[23];
  assign clock_hf = cnt[14];
  
  always @ (posedge clock_src) begin
    cnt <= cnt + 1'b1;
  end
  
  
endmodule