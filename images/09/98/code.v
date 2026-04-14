module d_flip_flop (  
    input wire D,  
    input wire CLK,  
    input wire RST_N,  
    output reg Q  
);  
    always @(posedge CLK or negedge RST_N) begin  
        if (!RST_N)  
            Q <= 1'b0;  
        else  
            Q <= D;  
    end  
endmodule