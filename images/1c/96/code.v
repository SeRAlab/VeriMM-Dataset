module TFlipFlop (  
    input clk,  
    input T,  
    input reset,  
    output reg Q  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            Q <= 0;  
        end else if (T) begin  
            Q <= ~Q;  
        end  
    end  
endmodule