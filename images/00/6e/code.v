module clock_gated_flip_flop (  
    input wire clk,  
    input wire gate,  
    input wire d,  
    output reg q  
);  
    always @(posedge clk) begin  
        if (gate) begin  
            q <= d;  
        end  
    end  
endmodule