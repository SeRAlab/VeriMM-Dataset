module comparator_32bit(  
    input [31:0] a,  
    input [31:0] b,  
    output reg eq  
);  
    always @(*) begin  
        if (a == b)  
            eq = 1'b1;  
        else  
            eq = 1'b0;  
    end  
endmodule