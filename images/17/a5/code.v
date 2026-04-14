module T_latch (  
    input T,  
    input enable,  
    output reg Q  
);  
    always @(T or enable) begin  
        if (enable) begin  
            if (T)  
                Q <= ~Q;  
        end  
    end  
endmodule