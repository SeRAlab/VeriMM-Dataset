module top_module(product, x, y);parameter width= 16;
parameter N = 8;


input[width-1:0]x, y;


output[width-1:0]product;


reg [2:0] count[N-1:0];
reg [width:0] partial[N-1:0];
reg [width+width-1:0] signedpartial[N-1:0];
reg [width+width-1:0] result;
wire [width:0] inv_x;


integer i,j;


assign inv_x = {~x[width-1],~x}+1;
always @ (x or y or inv_x)
begin
count[0] = {y[1],y[0],1'b0};
for(j=1;j<N;j=j+1)
count[j] = {y[2*j+1],y[2*j],y[2*j-1]};

for(j=0;j<N;j=j+1)
begin
case(count[j])  

3'b001 , 3'b010 : partial[j] = {x[width-1],x}; 
3'b011 : partial[j] = {x,1'b0};                
3'b100 : partial[j] = {inv_x[width-1:0],1'b0}; 
3'b101 , 3'b110 : partial[j] = inv_x;          
default : partial[j] = 0;                      
endcase
signedpartial[j] = $signed(partial[j]);
for(i=0;i<j;i=i+1)
signedpartial[j] = {signedpartial[j],2'b00}; 
end
result = signedpartial[0];
for(j=1;j<N;j=j+1)
result = result + signedpartial[j];
end
assign product = result ;endmodule