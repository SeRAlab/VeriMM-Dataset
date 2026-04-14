module sr_flip_flop (  
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
        // Maintain previous state if both inputs are low  
    end  
endmodule