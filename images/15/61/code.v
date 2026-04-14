module t_flip_flop(  
    input wire clk,  
    input wire CE,  
    input wire T,  
    output reg Q  
);  
  
    always @(posedge clk) begin  
        if (CE) begin  
            if (T)  
                Q <= ~Q;  
        end  
    end  
  
    initial begin  
        Q = 0;  
    end  
endmodule