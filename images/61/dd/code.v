module top_module(input [7:0] datos,output reg [7:0] data, input pl,input rtcoun,
input ver,input ver2,output reg Z=0,output reg write=0);reg [7:0] DP_RAM_data_in; 

reg f=0,x=0,y=0,w=0;
always @(*) 
begin
if(ver==1 & ver2==1 & pl==1)
begin
if( rtcoun==1)
begin
Z=0;
end
else begin
Z=1;
end

if( f==0 )
begin
DP_RAM_data_in [7:5]<=datos [7:5];
DP_RAM_data_in [4:2]<=datos [2:0];

end
end
end
always@(negedge pl)
begin
if (x==1)
begin
f=1;
x=0;
end
else begin
x=1;
end
if (y==1 & f==1)
begin
data<=DP_RAM_data_in; 
write=1;
f=0;


end
else begin
write=0;
end
end

always@(posedge pl)
begin
if (f==1)
begin
DP_RAM_data_in[1:0]<={datos[4:3]};
y=1;
end
else begin
y=0;
end
if(w==1)
begin

w=0;

end
else begin
w=1;
end
end

endmodule