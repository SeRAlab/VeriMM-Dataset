module priority_arbiter (  
    input wire req0,  
    input wire req1,  
    input wire req2,  
    input wire req3,  
    output reg grant  
);  
    always @(*) begin  
        if (req0) grant = 1'b1;  
        else if (req1) grant = 1'b1;  
        else if (req2) grant = 1'b1;  
        else if (req3) grant = 1'b1;  
        else grant = 1'b0;  
    end  
endmodule