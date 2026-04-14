module priority_encoder_6bit (data_in, encoded_out, valid);
   input [5:0] data_in;
   output reg [2:0] encoded_out;
   output reg valid;
   
   always @(*) begin
      valid = |data_in;
      if (valid) begin
         casez (data_in)
            6'b1?????: encoded_out = 3'b101;
            6'b01????: encoded_out = 3'b100;
            6'b001???: encoded_out = 3'b011;
            6'b0001??: encoded_out = 3'b010;
            6'b00001?: encoded_out = 3'b001;
            6'b000001: encoded_out = 3'b000;
            default: encoded_out = 3'bxxx;
         endcase
      end else begin
         encoded_out = 3'bxxx;
      end
   end
endmodule