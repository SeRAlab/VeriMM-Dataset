module TFlipFlop (  
    input wire clk,  
    input wire T,  
    input wire reset,  
    output reg Q  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset)  
            Q <= 0;  
        else if (T)  
            Q <= ~Q;  
    end  
endmodule