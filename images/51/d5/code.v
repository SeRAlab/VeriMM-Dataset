module priority_encoder_3bit (y, d);
   input [7:0] d;
   output [2:0] y;
   
   reg [2:0] y;
   
   always @(*) begin
      casez (d)
         8'b1???????: y = 3'b111;
         8'b01??????: y = 3'b110;
         8'b001?????: y = 3'b101;
         8'b0001????: y = 3'b100;
         8'b00001???: y = 3'b011;
         8'b000001??: y = 3'b010;
         8'b0000001?: y = 3'b001;
         8'b00000001: y = 3'b000;
         default: y = 3'b000;
      endcase
   end //End of always block
    
endmodule