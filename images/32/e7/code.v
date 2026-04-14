module RC_Oscillator #(parameter DIVISOR = 10) (  
    input wire clk,  
    output reg out  
);  
    reg [3:0] counter;  
    always @(posedge clk) begin  
        if (counter >= DIVISOR - 1) begin  
            counter <= 0;  
            out <= ~out;  
        end else begin  
            counter <= counter + 1;  
        end  
    end  
endmodule