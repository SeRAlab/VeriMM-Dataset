module DFlipFlop(  
    input wire clk,  
    input wire rst,  
    input wire D,  
    output reg Q  
);  
    always @(posedge clk or posedge rst) begin  
        if (rst)  
            Q <= 0;  
        else  
            Q <= D;  
    end  
endmodule