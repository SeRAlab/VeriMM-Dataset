module temperature_shutdown(  
    input clk,  
    input reset,  
    input [7:0] temperature,  
    output reg shutdown  
);  
    parameter HIGH_THRESHOLD = 8'd75;  
    parameter LOW_THRESHOLD = 8'd70;  
    reg state;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            shutdown <= 0;  
            state <= 0;  
        end else begin  
            case (state)  
                0: begin  
                    if (temperature > HIGH_THRESHOLD) begin  
                        shutdown <= 1;  
                        state <= 1;  
                    end  
                end  
                1: begin  
                    if (temperature < LOW_THRESHOLD) begin  
                        shutdown <= 0;  
                        state <= 0;  
                    end  
                end  
            endcase  
        end  
    end  
endmodule