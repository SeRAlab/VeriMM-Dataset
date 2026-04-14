module top_module(  
    clock,
    presureAbnormality,
    bloodAbnormality,
    fallDetected,
    temperatureAbnormality,
    nervousAbnormality,
    abnormaliryWarning);input clock;
input presureAbnormality;
input bloodAbnormality;
input fallDetected;
input temperatureAbnormality;
input [1:0] nervousAbnormality;
output reg [2:0] abnormaliryWarning;
reg[2:0] sum ; 
always @(presureAbnormality or bloodAbnormality or fallDetected or temperatureAbnormality or nervousAbnormality)
begin
	sum = presureAbnormality+bloodAbnormality+fallDetected+temperatureAbnormality+nervousAbnormality;
end
always @(posedge clock)
begin
	abnormaliryWarning = sum;
end
endmodule