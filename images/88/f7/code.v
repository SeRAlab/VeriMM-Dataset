module top_module(outcome,a,b,c);parameter size=8;
input[size:1] a,b; 
input c;
output[2*size:1] outcome; 
reg[2*size:1] outcome;
integer i;
always @(a or b)
	begin
	outcome=0;
	for(i=1; i<=size; i=i+1) 
		if(b[i]) outcome=outcome +(a << (i-1));
	end

always @(posedge c)
	begin
		outcome=0;
	end
endmodule