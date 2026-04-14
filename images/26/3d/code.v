module echo_cancellation (  
    input clk,  
    input rst,  
    input [15:0] audio_in,  
    input [15:0] reference_signal,  
    output reg [15:0] processed_signal  
);  
    reg [15:0] echo_estimate;  
    reg [1:0] state;  
    parameter IDLE = 2'b00, PROCESS = 2'b01, OUTPUT = 2'b10;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            echo_estimate <= 16'b0;  
            processed_signal <= 16'b0;  
            state <= IDLE;  
        end else begin  
            case (state)  
                IDLE: begin  
                    state <= PROCESS;  
                end  
                PROCESS: begin  
                    echo_estimate <= reference_signal; // Simple echo estimate  
                    state <= OUTPUT;  
                end  
                OUTPUT: begin  
                    processed_signal <= audio_in - echo_estimate;  
                    state <= IDLE;  
                end  
            endcase  
        end  
    end  
endmodule