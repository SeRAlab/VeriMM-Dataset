module T_latch (  
    input wire clk,  
    input wire enable,  
    input wire T,  
    output reg Q  
);  
    always @(posedge clk) begin  
        if (enable) begin  
            if (T)  
                Q <= ~Q;  
        end  
    end  
endmodule