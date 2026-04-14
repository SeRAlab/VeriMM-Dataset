module top_module( reset, a, b, c, en, o1, o2, o3, o4, o5);input  reset;
   input  a;
   input  b;
   input  c;
   input  en;
   output reg o1; 
   output reg o2; 
   output reg o3; 
   output reg o4; 
   output reg o5; 

always @(reset or en or a or b)
if (reset)
begin
    o1 = 1'b0;
    o2 = 1'b0;
    o3 = 1'b0;
    o4 = 1'b0;
    o5 <= 1'b0; 
end
else
begin
    o1 = 1'b1;
    if (en)
    begin
        o2 = 1'b0;

	    if (a)
	    begin
            o3 = a;
            o5 <= 1'b1; 
	    end
	    else
	    begin
            o3 = ~a;
            o5 <=  a; 
	    end

        
        
	    if (c)
	    begin
            o2 = a ^ b;
            o4 = 1'b1;
        end
	    else
            o4 = ~a ^ b;

        o2 = 1'b1;
    end
    else
    begin
        o2 = 1'b1;
	    if (b)
        begin
            o3 = ~a | b;
            o5 <= ~b; 
	    end
	    else
	    begin
            o3 = a & ~b;
            
	    end
        o4 <= 1'b0; 
    end
end

endmodule