module echo_cancellation (  
    input clk,  
    input reset,  
    input [15:0] audio_in,  
    input [15:0] echo_in,  
    output reg [15:0] audio_out  
);  
    reg [15:0] echo_buffer [0:4];  
    integer i;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            audio_out <= 16'b0;  
            for (i = 0; i < 5; i = i + 1)  
                echo_buffer[i] <= 16'b0;  
        end else begin  
            // Shift the echo_buffer  
            for (i = 4; i > 0; i = i - 1)  
                echo_buffer[i] <= echo_buffer[i - 1];  
            echo_buffer[0] <= echo_in;  

            // Calculate the output  
            audio_out <= audio_in - echo_buffer[0];  
        end  
    end  
endmodule