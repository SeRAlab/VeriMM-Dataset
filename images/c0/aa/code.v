module ALU(input[8:0] ALU_A , input[8:0] ALU_B , input SU , input AD , input EU , output[8:0] ALU_OUT);
wire [8:0] ALU_OUT_w;
assign ALU_OUT_w = SU ? ALU_A - ALU_B : AD ? ALU_A + ALU_B : ALU_OUT_w;
assign ALU_OUT = EU ? ALU_OUT_w : 9'h000;
endmodule