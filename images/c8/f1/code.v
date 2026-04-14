module input_to_output (input [3:0] in, output [1:0] out);
   always @(*) begin
      case (in)
         0,1,2,3: out = 2'b00;
         4,5,6,7: out = 2'b01;
         8,9,10,11: out = 2'b10;
         default: out = 2'b11;
      endcase
   end
endmodule