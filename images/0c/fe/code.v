module T_latch (  
    input wire T,  
    input wire clock,  
    output reg Q  
);  
    always @(posedge clock) begin  
        if (T)  
            Q <= ~Q;  
    end  
endmodule