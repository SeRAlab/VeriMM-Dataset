module butterworth_filter (  
    input [4:0] x,  
    output reg [4:0] y  
);  
    reg [4:0] a1, a2;  
    reg [4:0] b1, b2;  

    always @* begin  
        a1 = x;  
        a2 = b1;  
        b1 = (a1 + a2) >> 1; // averaging  
        y = b1;  
    end  
endmodule