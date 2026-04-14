module top_module(
input [31:0] a,
input [31:0] b,
input [3:0] ALU_op,
output reg [31:0] ALU_out,
output reg less,
output reg zero,
output reg overflow
);reg [2:0] ALU_ctr;
reg [31:0] result [7:0];
reg carry;
reg OF;
reg negative;
reg [31:0] temp;
reg [31:0] b_not;
reg flag;
integer i;

always@(*)
begin
case(ALU_op)  
4'b0000:ALU_ctr=3'b111;
4'b0001:ALU_ctr=3'b111;
4'b0010:ALU_ctr=3'b000;
4'b0011:ALU_ctr=3'b000;
4'b0100:ALU_ctr=3'b100;
4'b0101:ALU_ctr=3'b101;
4'b0110:ALU_ctr=3'b010;
4'b0111:ALU_ctr=3'b101;
4'b1000:ALU_ctr=3'b011;
4'b1001:ALU_ctr=3'b001;
4'b1010:ALU_ctr=3'b110;
4'b1011:ALU_ctr=3'b110;
4'b1110:ALU_ctr=3'b111;
4'b1111:ALU_ctr=3'b111;
default:ALU_ctr=3'b000;
endcase
if(ALU_op[0]==0)  
b_not=b^32'h00000000;
else
b_not=b^32'hffffffff;

{carry,result[7]}=b_not+a+ALU_op[0];
OF=((~a[31])&(~b_not[31])&result[7][31])|(a[31]&(b_not[31])&(~result[7][31]));
negative=result[7][31];
if(result[7]==32'b0)
zero=1;
else
zero=0;


overflow=OF&ALU_op[1]&&ALU_op[2]&&ALU_op[3];


if(ALU_op[0]&&ALU_op[1]&&ALU_op[2]&&(!ALU_op[3]))
less=!carry;
else
less=OF^negative;

if(ALU_op[0]==1) 
begin
if(b[15]==0)
result[6]={16'h0000,b[15:0]};
else
result[6]={16'hffff,b[15:0]};
end
else
begin
if(b[7]==0)
result[6]={24'h000000,b[7:0]};
else
result[6]={24'hffffff,b[7:0]};
end

if(less==0) 

result[5]=32'h00000000;
else
result[5]=32'hffffffff;

result[4]=a&b;

result[3]=~(a|b);

result[2]=(a|b);

result[1]=a^b;

if(ALU_op[0]==0) 
temp=a^32'h00000000;
else
temp=a^32'hffffffff;

result[0]=32'h00000000;
flag=0;
for(i=31;i>=0;i=i-1)
begin
if(flag==0&&temp[i]==0)
result[0]=result[0]+32'h00000001;
if(temp[i]==1)
flag=1;
end

ALU_out=result[ALU_ctr];
end
endmodule