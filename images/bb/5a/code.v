module priority_encoder_8bit(
    input wire [7:0] in,
    output wire [2:0] out
    );

assign out = (in[7]) ? 3'b111 :
             (in[6]) ? 3'b110 :
             (in[5]) ? 3'b101 :
             (in[4]) ? 3'b100 :
             (in[3]) ? 3'b011 :
             (in[2]) ? 3'b010 :
             (in[1]) ? 3'b001 :
                       3'b000;

endmodule