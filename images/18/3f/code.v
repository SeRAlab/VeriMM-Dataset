module sr_flip_flop (  
    input wire S,  
    input wire R,  
    input wire clk,  
    output reg Q,  
    output reg Qn  
);  
    always @(posedge clk) begin  
        if (S && !R) begin  
            Q <= 1;  
            Qn <= 0;  
        end else if (!S && R) begin  
            Q <= 0;  
            Qn <= 1;  
        end  
        // When both S and R are low, maintain the state  
        // When both S and R are high, hold the previous state  
    end  
endmodule