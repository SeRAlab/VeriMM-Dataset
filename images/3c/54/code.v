module T_latch (  
    input wire T,  
    input wire clk,  
    output reg Q  
);  
    always @(posedge clk) begin  
        if (T)  
            Q <= ~Q;  
    end  
endmodule