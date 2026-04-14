module priority_encoder_16bit (out, valid, in);
   input [15:0] in;
   output [3:0] out;
   output valid;
   
   reg [3:0] out;
   reg valid;
   
   always @(*) begin
      casez (in)
         16'b1???????????????: begin out = 4'b1111; valid = 1; end
         16'b01??????????????: begin out = 4'b1110; valid = 1; end
         16'b001?????????????: begin out = 4'b1101; valid = 1; end
         16'b0001????????????: begin out = 4'b1100; valid = 1; end
         16'b00001???????????: begin out = 4'b1011; valid = 1; end
         16'b000001??????????: begin out = 4'b1010; valid = 1; end
         16'b0000001?????????: begin out = 4'b1001; valid = 1; end
         16'b00000001????????: begin out = 4'b1000; valid = 1; end
         16'b000000001???????: begin out = 4'b0111; valid = 1; end
         16'b0000000001??????: begin out = 4'b0110; valid = 1; end
         16'b00000000001?????: begin out = 4'b0101; valid = 1; end
         16'b000000000001????: begin out = 4'b0100; valid = 1; end
         16'b0000000000001???: begin out = 4'b0011; valid = 1; end
         16'b00000000000001??: begin out = 4'b0010; valid = 1; end
         16'b000000000000001?: begin out = 4'b0001; valid = 1; end
         16'b0000000000000001: begin out = 4'b0000; valid = 1; end
         default: begin out = 4'b0000; valid = 0; end
      endcase
   end
   
endmodule