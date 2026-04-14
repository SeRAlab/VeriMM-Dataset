module SR_FlipFlop (  
    input S,  
    input R,  
    input clk,  
    output reg Q,  
    output reg Qn  
);  
    always @(posedge clk) begin  
        if (S && !R) begin  
            Q <= 1;  
        end else if (!S && R) begin  
            Q <= 0;  
        end  
        Qn <= ~Q;  
    end  
endmodule