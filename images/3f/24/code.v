module T_latch (  
    input wire T,  
    input wire CLK,  
    input wire RST,  
    output reg Q  
);  
    always @(posedge CLK or posedge RST) begin  
        if (RST) begin  
            Q <= 0;  
        end else if (T) begin  
            Q <= ~Q;  
        end  
    end  
endmodule