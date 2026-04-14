module sr_flip_flop (  
    input wire S,  
    input wire R,  
    input wire clk,  
    output reg Q  
);  
    always @(posedge clk) begin  
        if (S && ~R) begin  
            Q <= 1;  
        end else if (~S && R) begin  
            Q <= 0;  
        end else if (~S && ~R) begin  
            Q <= Q;  // Retain the state  
        end else if (S && R) begin  
            // Invalid state, do nothing (or can set Q to a default state if needed)  
        end  
    end  
endmodule