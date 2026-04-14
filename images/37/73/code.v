module pitch_detector(  
    input clk,  
    input reset,  
    input [7:0] frequency_input,  
    output reg [7:0] detected_pitch  
);  
    reg [1:0] state;  
    parameter IDLE = 2'b00, DETECT = 2'b01, OUTPUT = 2'b10;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= IDLE;  
            detected_pitch <= 8'b00000000;  
        end else begin  
            case (state)  
                IDLE: begin  
                    if (frequency_input != 8'b00000000)  
                        state <= DETECT;  
                end  
                DETECT: begin  
                    detected_pitch <= frequency_input;  
                    state <= OUTPUT;  
                end  
                OUTPUT: begin  
                    if (frequency_input == 8'b00000000)  
                        state <= IDLE;  
                end  
            endcase  
        end  
    end  
endmodule