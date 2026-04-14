module top_module(clk, res, shift, mux, outp);input clk,res;
  input [31:0] mux;
  input [7:0] shift;
  reg [7:0] tmp;
  reg [26:0] fra = 0;
  output reg [26:0] outp; 
  always @(posedge clk) begin
    if(shift)
      begin
        fra[24:2] = mux[22:0]; 
        tmp = shift - 128;
        fra[25] = 1; 
        outp[24:0] = fra>>tmp;
        outp[26] = mux[31]; 
      end
    if(!res)
      outp = 0;
    end
endmodule