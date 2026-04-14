module T_latch (  
    input wire T,  
    input wire clk,  
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