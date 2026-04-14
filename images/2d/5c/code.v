module T_latch (  
    input clk,  
    input T,  
    output reg Q  
);  
    always @(posedge clk) begin  
        if (T)  
            Q <= ~Q;  
    end  
endmodule