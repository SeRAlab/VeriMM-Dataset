module d_latch (  
    input wire D,  
    input wire CLK,  
    input wire RESET,  
    output reg Q  
);  
    always @(posedge CLK or posedge RESET) begin  
        if (RESET)  
            Q <= 1'b0;  
        else  
            Q <= D;  
    end  
endmodule