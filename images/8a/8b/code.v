module top_module(
    input clk, 
    input [2:0]s,
    input [5:0]a,
    input [5:0]b,
    output reg cf, 
    output reg of,
    output reg zf,
    output reg[5:0]y 
);always @(posedge clk) begin
    case (s)  
    
      3'b000: begin
        {cf,y}={1'b0,a}+{1'b0,b};
        of=(~a[5]&~b[5]&y[5]|a[5]&b[5]&~y[5]);
      end
    
      3'b001: begin
        {cf,y}=a-b;
        of=(~a[5]&b[5]&~y[5]|a[5]&~b[5]&~y[5]);
      end
    
      3'b010: y=a&b;
    
      3'b011: y=a|b;
    
      3'b100: y=~a;
    
      3'b101: y=a^b;
    
      3'b110: begin
        y={a[4:0],1'b0};
      end 
    
      default:begin
        y={1'b0,a[5:1]};
      end
    endcase

    zf=~|y;

end

endmodule