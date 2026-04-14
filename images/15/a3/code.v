module fixed_priority_arbiter (  
    input wire clk,  
    input wire reset,  
    input wire req0,  
    input wire req1,  
    input wire req2,  
    output reg grant  
);  

always @(posedge clk or posedge reset) begin  
    if (reset)  
        grant <= 0;  
    else begin  
        if (req0)  
            grant <= 1;  
        else if (req1)  
            grant <= 2;  
        else if (req2)  
            grant <= 3;  
        else  
            grant <= 0;  
    end  
end  
endmodule