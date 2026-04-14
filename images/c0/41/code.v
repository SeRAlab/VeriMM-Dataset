module ADDR_ROM(input [4:0] IR_OUT , input CS , output [4:0] AR_OUT);
reg [4:0] AR_OUT_r[15:0];
assign AR_OUT = AR_OUT_r[IR_OUT];
always@(CS) 
begin
AR_OUT_r[0] <= 5'b00100;
AR_OUT_r[1] <= 5'b00111;
AR_OUT_r[2] <= 5'b01100;
AR_OUT_r[3] <= 5'b10001;
AR_OUT_r[4] <= 5'hFF;
AR_OUT_r[5] <= 5'hFF;
AR_OUT_r[6] <= 5'hFF;
AR_OUT_r[7] <= 5'hFF;
AR_OUT_r[8] <= 5'hFF;
AR_OUT_r[9] <= 5'hFF;
AR_OUT_r[10] <= 5'hFF;
AR_OUT_r[11] <= 5'hFF;
AR_OUT_r[12] <= 5'hFF;
AR_OUT_r[13] <= 5'hFF;
AR_OUT_r[14] <= 5'hFF;
AR_OUT_r[15] <= 5'hFF;
end
endmodule