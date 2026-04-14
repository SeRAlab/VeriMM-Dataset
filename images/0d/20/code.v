module SR_flip_flop (  
    input wire S,  
    input wire R,  
    input wire clk,  
    output reg Q  
);  
    always @(posedge clk) begin  
        if (S && ~R)  
            Q <= 1;  
        else if (~S && R)  
            Q <= 0;  
        // If S = 1 and R = 1, do nothing (hold state)  
    end  
endmodule