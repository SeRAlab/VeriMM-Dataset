module d_flip_flop (  
    input wire clk,  
    input wire D,  
    output reg Q,  
    output wire Qn  
);  
    assign Qn = ~Q;  
    always @(posedge clk) begin  
        Q <= D;  
    end  
endmodule