module sr_flip_flop (  
    input wire S,  
    input wire R,  
    input wire RESET,  
    output reg Q  
);  
    always @(posedge RESET or posedge S or posedge R) begin  
        if (RESET)  
            Q <= 0;  
        else if (S)  
            Q <= 1;  
        else if (R)  
            Q <= 0;  
    end  
endmodule