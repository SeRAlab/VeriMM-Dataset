module priority_encoder_4bit (enc_out, data_in);
   input [3:0] data_in;
   output [1:0] enc_out;
   
   reg [1:0] enc_out;
   
   always @(*) begin
      casez (data_in)
         4'b1???: enc_out = 2'b11;
         4'b01??: enc_out = 2'b10;
         4'b001?: enc_out = 2'b01;
         4'b0001: enc_out = 2'b00;
         default: enc_out = 2'b00;
      endcase
   end
   
endmodule