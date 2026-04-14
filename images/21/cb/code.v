module T_FlipFlop (  
    input wire clk,  
    input wire T,  
    output reg Q  
);  
    always @(posedge clk) begin  
        if (T)  
            Q <= ~Q;  
    end  
endmodule