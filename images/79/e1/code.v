module binary_to_bcd(
    input       [3:0]   bin_in     ,
    
    output  reg [3:0]   bcd_out
);
    
   always @(*) begin
       case(bin_in)
           4'b0000: bcd_out = 4'b0000; // 0
           4'b0001: bcd_out = 4'b0001; // 1
           4'b0010: bcd_out = 4'b0010; // 2
           4'b0011: bcd_out = 4'b0011; // 3
           4'b0100: bcd_out = 4'b0100; // 4
           4'b0101: bcd_out = 4'b0101; // 5
           4'b0110: bcd_out = 4'b0110; // 6
           4'b0111: bcd_out = 4'b0111; // 7
           4'b1000: bcd_out = 4'b1000; // 8
           4'b1001: bcd_out = 4'b1001; // 9
           default: bcd_out = 4'b0000; // invalid input
       endcase
   end
     
endmodule