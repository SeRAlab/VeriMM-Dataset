module priority_encoder_8bit (in, out);
   input [7:0] in;
   output [2:0] out;

   reg [2:0] out;

always @(*) begin
    casex (in)
        8'b10000000: out = 3'b111;
        8'b01xxxxxx: out = 3'b110;
        8'b001xxxxx: out = 3'b101;
        8'b0001xxxx: out = 3'b100;
        8'b00001xxx: out = 3'b011;
        8'b000001xx: out = 3'b010;
        8'b0000001x: out = 3'b001;
        8'b00000001: out = 3'b000;
        default: out = 3'b000;
    endcase
end

endmodule