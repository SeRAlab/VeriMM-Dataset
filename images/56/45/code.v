module top_module(in,out);input [7:0] in; 
output reg [7:0]out;
integer number;
integer unit;
integer decena;
reg [3:0]temp;
always @(in) begin
    number = in;
    unit = number%10;
    decena = (number-unit)/10;
    temp = decena;
    out[4]=temp[0];
    out[5]=temp[1];
    out[6]=temp[2];
    out[7]=temp[3];
    temp=unit;
    out[0]=temp[0];
    out[1]=temp[1];
    out[2]=temp[2];
    out[3]=temp[3];    
end
endmodule