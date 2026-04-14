module top_module(a,b,bin,d,bout );input a;
    input b;
    input bin;
    output d; 
    output bout;
    
    assign d=a^b^bin;
    assign bout= ~a&b | b&bin | bin&~a;
       
endmodule