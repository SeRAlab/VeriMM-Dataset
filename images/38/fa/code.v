module pitch_detection(clk, reset, audio_signal, pitch_output);  
    input clk;  
    input reset;  
    input [3:0] audio_signal;  
    output reg [2:0] pitch_output;  

    reg [1:0] state;  
    parameter IDLE = 2'b00, DETECTING = 2'b01, OUTPUT = 2'b10;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= IDLE;  
            pitch_output <= 3'b000;  
        end else begin  
            case (state)  
                IDLE: begin  
                    if (audio_signal != 4'b0000)  
                        state <= DETECTING;  
                end  
                DETECTING: begin  
                    if (audio_signal < 4'b0100)  
                        pitch_output <= 3'b001;  // C note  
                    else if (audio_signal < 4'b1000)  
                        pitch_output <= 3'b010;  // D note  
                    else  
                        pitch_output <= 3'b011;  // E note  
                    state <= OUTPUT;  
                end  
                OUTPUT: begin  
                    state <= IDLE;  
                end  
            endcase  
        end  
    end  
endmodule