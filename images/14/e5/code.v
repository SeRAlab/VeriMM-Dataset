module fixed_priority_arbiter(  
    input wire req0,  
    input wire req1,  
    input wire req2,  
    output reg grant0,  
    output reg grant1,  
    output reg grant2  
);  

always @(*) begin  
    // Default grant signals  
    grant0 = 0;  
    grant1 = 0;  
    grant2 = 0;  

    // Fixed priority logic  
    if (req0) begin  
        grant0 = 1;  
    end else if (req1) begin  
        grant1 = 1;  
    end else if (req2) begin  
        grant2 = 1;  
    end  
end  
endmodule