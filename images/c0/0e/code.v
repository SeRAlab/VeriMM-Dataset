module register5_wlh(datain, dataout, load, hold, clock);
input [4:0] datain;
input load, hold;
input clock;
output [4:0] dataout;
reg [4:0] out;
always @(posedge clock)
begin
    if(load)
       out <= datain;
    else if(hold)
       out <= out;
    else
       out <= 5'b0;
end
assign dataout = out;
endmodule