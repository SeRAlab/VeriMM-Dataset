module top_module(seleksioni,data1,data2,data3,data4,data5,data6,data7,data8,dalja
    );input [2:0] seleksioni;
input data1;
input data2;
input data3;
input data4;
input data5;
input data6;
input data7;
input data8;
output dalja;
reg dalja;
always @ (seleksioni or data1,data2,data3,data4,data5,data6,data7,data8)
begin
case (seleksioni)
3'b000: dalja = data1;
3'b001: dalja = data2;
3'b010 : dalja = data3;
3'b011 : dalja = data4;
3'b100 : dalja = data5;
3'b101 : dalja = data6;
3'b110 : dalja = data7;
3'b111 : dalja = data8;
endcase
end
endmodule