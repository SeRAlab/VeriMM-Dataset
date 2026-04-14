module SR_FlipFlop (input S, input R, input CLK, output reg Q, output reg Qbar);  
    always @(posedge CLK) begin  
        if (S && !R) begin  
            Q <= 1;  
        end else if (!S && R) begin  
            Q <= 0;  
        end else if (!S && !R) begin  
            Q <= Q; // Retain previous state  
        end else begin  
            // Invalid state, do nothing  
        end  
        Qbar <= ~Q;  
    end  
endmodule