module regkr(datain, dataout, load, initialize, clock);
input [4:0] datain;
input load, initialize;
input clock;
output [4:0] dataout;
reg [4:0] out;
always @(posedge clock)
begin
    if(initialize)
       out <= 5'b0;
    else if(load)
       out <= datain;
    else
       out <= 5'b0;
end
assign dataout = out;
endmodule