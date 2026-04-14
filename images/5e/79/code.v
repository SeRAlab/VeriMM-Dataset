module top_module(dout, strobe, din, clk);output [3:0] dout;
output strobe;
input din, clk;

reg [9:0] shift_reg = 0;

always @(posedge clk)
    shift_reg <= (strobe ? 10'b0 :                  
                           {shift_reg[8:0], din});  


assign strobe = (shift_reg[9:6] == 4'b0101 &&  
                 ^shift_reg[9:1]);             

assign dout = (strobe ? shift_reg[5:2] : 4'b0);

endmodule