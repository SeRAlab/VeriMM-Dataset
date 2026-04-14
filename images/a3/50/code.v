module binary_decoder_1to2(
    input       [0:0]   bin_in     ,
 
    output  reg [1:0]   one_hot_out
);
    
   // one_hot_out
   always @(*) begin
       case(bin_in)
           1'b0: one_hot_out = 2'b01;
           1'b1: one_hot_out = 2'b10;
           default: one_hot_out = 2'b00;
       endcase
   end
     
endmodule