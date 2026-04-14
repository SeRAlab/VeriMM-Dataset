module top_module(clk_in, enable,reset, clk_out);input               clk_in                   ;
 input               reset                    ;
 input               enable                   ;
 output              clk_out                  ;
 
 wire                 clk_in                  ;
 wire                 enable                  ;

reg                   clk_out                 ;

always @ (posedge clk_in) 
if (reset) begin 
  clk_out <= 1'b0;
end else if (enable) begin
  clk_out <= !clk_out ; 
end

endmodule