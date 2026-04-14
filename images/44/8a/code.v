module top_module(datain0, datain1, datain2, datain3, dataout, select);input [31:0] datain0, datain1, datain2, datain3;
input[1:0] select;
output [31:0] dataout; 
reg [31:0] dataout;

always@(datain0 or datain1 or datain2 or datain3 or select)
begin
  case(select)
  2'b00:  dataout = datain0;
  2'b01:  dataout = datain1;
  2'b10:  dataout = datain2;
  2'b11:  dataout = datain3;
  endcase
end

endmodule