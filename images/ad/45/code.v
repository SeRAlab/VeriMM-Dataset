module top_module(a, b, aluc, result);input wire [31:0] a; 
input wire [31:0] b; 
input wire [3:0] aluc; 
output reg [31:0] result; 
wire [31:0] addresult;
wire [31:0] subresult;
wire co1,co2; 
assign addresult=a+b;
assign subresult=a-b;


always @* begin
case(aluc)
4'b0001: begin result<=a & b; end 
4'b1001: begin result<=a & b; end 
4'b0101: begin result<=a|b; end 
4'b1101: begin result<=a|b; end 
4'b1010: begin result<=a^b; end 
4'b0010: begin result<=a^b; end 
4'b0110: begin result<=b<<16;end
4'b1110: begin result<=b<<16;end
4'b0000: begin result<=addresult; end 
4'b1000: begin result<=addresult; end 
4'b0100: begin result<=subresult; end 
4'b1100: begin result<=subresult; end 
4'b0011: begin result<=b<<a; end
4'b0111: begin result<=b>>a; end
4'b1111: begin result<=($signed(b))>>>a; end
default: begin result<=addresult; end

endcase end
endmodule