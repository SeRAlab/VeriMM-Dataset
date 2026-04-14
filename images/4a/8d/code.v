module top_module(
    input Clock,
    input Reset,
    input LoadChar,
    input [6:0]Ascii,
    output reg New,
    output reg [6:0] Char
);always @(posedge Clock)begin
	if(Reset==1)begin 
		Char=7'h0; 
		New=0; 
	end else begin 
		if(LoadChar==1)begin 
			New=1;
			Char=Ascii;
		end else New=0;
	end
end
	
endmodule