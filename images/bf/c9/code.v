module register5_wl(datain, dataout, clock, load);
input [4:0] datain;
output [4:0] dataout;
input clock, load;
reg [4:0] dataout;
always@(posedge clock)
begin
    if(load)
       dataout <= datain;
    else
       dataout <= 5'b0;
end
endmodule