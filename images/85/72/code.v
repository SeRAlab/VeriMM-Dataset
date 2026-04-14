module top_module(
input   wire    [1:0]   a,  
input   wire    [1:0]   b,  
input   wire    [1:0]   c,  
input   wire    [1:0]   d,  
input   wire    [1:0]   sel,    

output  reg     [1:0]   out 
);always @(a or b or c or d or sel)
begin
    case(sel)
        2'b00   :   out = a;
        2'b01   :   out = b;
        2'b10   :   out = c;
        2'b11   :   out = d;
        
        
    endcase
end

endmodule