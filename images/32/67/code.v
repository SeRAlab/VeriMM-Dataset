module phase_detector (  
    input wire A,  
    input wire B,  
    input wire clk,  
    output reg phase_high,  
    output reg phase_low  
);  
    always @(posedge clk) begin  
        if (A && !B) begin  
            phase_high <= 1;  
            phase_low <= 0;  
        end else if (!A && B) begin  
            phase_high <= 0;  
            phase_low <= 1;  
        end else begin  
            phase_high <= 0;  
            phase_low <= 0;  
        end  
    end  
endmodule