module SR_FF (  
    input wire S,  
    input wire R,  
    input wire clk,  
    output reg Q,  
    output reg Qn  
);  
    always @(posedge clk) begin  
        if (S && ~R) begin  
            Q <= 1;  
            Qn <= 0;  
        end else if (~S && R) begin  
            Q <= 0;  
            Qn <= 1;  
        end else if (S && R) begin  
            // Undefined state, can be handled as needed  
        end  
        // Maintain current state  
    end  
endmodule