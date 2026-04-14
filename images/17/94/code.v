module T_latch (  
    input wire T,  
    input wire enable,  
    output reg Q  
);  
    always @(enable or T) begin  
        if (enable) begin  
            Q <= T;  
        end  
    end  
endmodule