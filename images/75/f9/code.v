module top_module(d,a,b,cin,f);input cin;
    input [3:0]a,b;
    input [3:0]f;
    
    
    output [7:0]d;
    reg [7:0]d;
    
    
    always@(f,a,b,cin)
    begin
        case(f)
           
            4'b0000:
                     d=!a;
            4'b0001:
                    d=a-b-cin;
            4'b0010:
                    d=a+b+cin;
            4'b0011:
                    d=a&&b;
            4'b0100:
                    d=a||b;
            4'b0101:
                    d=a^b;
            4'b0110: 
                    d=!(a^b);
            4'b0111:
                     d=a*b;
            4'b1000:
                    d=a/b;
            4'b1001:
                    d=a<<1;
            4'b1010:
                     d=a>>1;
            4'b1011:
                     d=a+1;
            4'b1100:
                     d=a-1;
        
        
        endcase
    end
    
endmodule