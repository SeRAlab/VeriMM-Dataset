module pitch_detector (  
    input wire clk,  
    input wire rst,  
    input wire [7:0] audio_signal,  
    output reg [3:0] detected_pitch  
);  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            detected_pitch <= 4'b0000;  
        end else begin  
            if (audio_signal < 8'd50)  
                detected_pitch <= 4'b0001; // Low pitch  
            else if (audio_signal < 8'd100)  
                detected_pitch <= 4'b0010; // Medium pitch  
            else  
                detected_pitch <= 4'b0011; // High pitch  
        end  
    end  
endmodule