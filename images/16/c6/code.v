module rc_oscillator #(parameter N = 8) (  
    input clk,  
    input reset,  
    output reg out  
);  
    reg [N-1:0] counter;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            out <= 0;  
            counter <= 0;  
        end else begin  
            counter <= counter + 1;  
            if (counter == (1 << N) - 1) begin  
                out <= ~out;  
                counter <= 0;  
            end  
        end  
    end  
endmodule