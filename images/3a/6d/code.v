module T_flip_flop (  
    input wire T,  
    input wire CLK,  
    input wire RST,  
    output reg Q  
);  
    always @(posedge CLK or posedge RST) begin  
        if (RST)  
            Q <= 0;  
        else if (T)  
            Q <= ~Q;  
    end  
endmodule