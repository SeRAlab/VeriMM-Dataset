module top_module(input wire s1_1, s0_1,ACCESO_2,B4,B3,B2,B1,A4,A3,A2,A1,ATRAS, output wire sf1_1,sf0_1, ACCESO_1, Solicitar_Tarjeta,Solicitar_Pin);assign sf1_1 = (s1_1& ~s0_1 & ACCESO_2) |( ~s1_1& s0_1& ~B4& ~B3& ~B2& B1& ~ATRAS);
assign sf0_1 = (~s1_1& s0_1 &~B1& ~ATRAS) |( ~s1_1& ~s0_1& ~A4& ~A3& ~A2 & A1& ~ACCESO_2) ;
assign ACCESOO_1 = (s1_1& ~s0_1& ACCESO_2 ) |( ~s1_1& s0_1& ~B4& ~B3 &~B2 &B1& ~ATRAS);
assign Solicitar_Tarjeta = (s1_1& ~s0_1 & ~ACCESO_2)  |( ~s0_1& ~A1& ~ACCESO_2)  | ( ~s1_1& s0_1& ATRAS);
assign Solicitar_Pin = (~s1_1& s0_1&~ B1& ~ATRAS) | (~s1_1& ~s0_1& ~A4& ~A3& ~A2& A1 &~ACCESO_2);endmodule