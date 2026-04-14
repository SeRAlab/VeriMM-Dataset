module DFlipFlop (  
    input wire D,  
    input wire clk,  
    input wire rst,  
    input wire en,  
    output reg Q  
);  
    always @(posedge clk or posedge rst) begin  
        if (rst)  
            Q <= 0;  
        else if (en)  
            Q <= D;  
    end  
endmodule