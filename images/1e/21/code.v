module T_latch (  
    input wire T,  
    input wire CLK,  
    output reg Q  
);  
    always @(posedge CLK) begin  
        if (T)  
            Q <= ~Q;  
    end  
endmodule