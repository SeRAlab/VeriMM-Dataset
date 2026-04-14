module top_module(
    
    input      wb_clk_i,
    input      wb_rst_i,
    output reg wb_tgc_o,   
    input      wb_tgc_i    
  );reg [17:0] cnt;
  reg        old_clk2;
  reg        pulse;
  wire       clk2;

  
  assign clk2 = cnt[17];

  
  
  always @(posedge wb_clk_i)
    cnt <= wb_rst_i ? 18'h00 : (cnt + 18'h1);

  
  always @(posedge wb_clk_i)
    old_clk2 <= wb_rst_i ? 1'b0 : clk2;

  
  always @(posedge wb_clk_i)
    pulse <= wb_rst_i ? 1'b0 : (clk2!=old_clk2);

  
  always @(posedge wb_clk_i)
    wb_tgc_o <= wb_rst_i ? 1'b0
      : ((pulse & !wb_tgc_i) ? 1'b1
      : (wb_tgc_o ? !wb_tgc_i : 1'b0));
endmodule