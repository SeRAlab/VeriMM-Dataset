module d_flip_flop (  
    input wire D,  
    input wire clk,  
    input wire reset,  
    input wire set,  
    output reg Q  
);  
    always @(posedge clk or posedge reset or posedge set) begin  
        if (reset)  
            Q <= 1'b0;  
        else if (set)  
            Q <= 1'b1;  
        else  
            Q <= D;  
    end  
endmodule