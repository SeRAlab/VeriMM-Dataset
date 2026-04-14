module simple_rnn(  
    input clk,  
    input reset,  
    input x,  
    output reg y  
);  
    reg state;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= 0;  
            y <= 0;  
        end else begin  
            state <= x;  
            y <= state;  
        end  
    end  
endmodule