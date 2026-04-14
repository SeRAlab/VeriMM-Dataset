module binary_decoder_3to8(
    input       [2:0]   bin_in     ,
 
    output  reg [7:0]   one_hot_out
);
    
   // one_hot_out
   always @(*) begin
       case(bin_in)
           3'b000: one_hot_out = 8'b00000001;
           3'b001: one_hot_out = 8'b00000010;
           3'b010: one_hot_out = 8'b00000100;
           3'b011: one_hot_out = 8'b00001000;
           3'b100: one_hot_out = 8'b00010000;
           3'b101: one_hot_out = 8'b00100000;
           3'b110: one_hot_out = 8'b01000000;
           3'b111: one_hot_out = 8'b10000000;
           default: one_hot_out = 8'b00000000;
       endcase
   end
     
endmodule