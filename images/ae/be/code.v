module top_module(
 HSV1,HSV2,outHSV
);input[31:0] HSV1 ;
input[31:0] HSV2 ;
output [31:0] outHSV ;





assign outHSV[7:0]=( 8'b10100000 <= HSV1[31:24] && HSV1[31:24] <= 8'b10111001 && 8'b01100100 <= HSV1[23:16]  && 8'd50 <= HSV1[15:8] )?(8'b11111111):8'b00000000;

assign outHSV[15:8]=( 8'b00011111 <= HSV2[31:24] && HSV2[31:24] <= 8'b01001001 && 8'b00111100 <= HSV2[23:16]  && 8'b00111100 <= HSV2[15:8] )?(8'b11111111):8'b00000000;
endmodule