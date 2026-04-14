module sr_flip_flop (  
    input wire S,  
    input wire R,  
    input wire clk,  
    output reg Q  
);  
    always @(posedge clk or posedge R or posedge S) begin  
        if (R)  
            Q <= 0;  
        else if (S)  
            Q <= 1;  
        // else case: Q retains its state  
    end  
endmodule