module top_module(in1,in2,control,result,zero);input [31:0] in1,in2;
output zero;
reg zero=0;
input [3:0]control;
output [31:0]result;
reg [31:0]result;
always @(*)begin
if (control==4'b0010) begin result=in1+in2; zero=0;end      
else if (control==4'b0110) begin 
result=in1-in2; 
if (in1==in2) begin zero=1;end
end       
else if (control==4'b0000) begin result=in1 & in2; zero=0;end  
else if (control==4'b0001) begin result=in1 | in2; zero=0;end   
else if (control==4'b0111) begin  
if (in1<in2) begin result=1; end
else begin result=0; end               
end

end
endmodule