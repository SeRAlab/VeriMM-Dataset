module register_pe(datain, initdata, dataout, load, initialize, hold, clock);
input [4:0] datain, initdata;
input load, hold, initialize;
input clock;
output [4:0] dataout;
reg [4:0] out;
always @(posedge clock)
begin
    if(initialize)
       out <= initdata;
    else if(load)
       out <= datain;
    else if(hold)
       out <= out;
    else
       out <= 5'b0;
end
assign dataout = out;
endmodule