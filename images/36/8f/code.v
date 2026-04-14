module d_flip_flop (  
    input wire D,  
    input wire clk,  
    input wire en,  
    output reg Q  
);  
    always @(posedge clk) begin  
        if (en)  
            Q <= D;  
    end  
endmodule