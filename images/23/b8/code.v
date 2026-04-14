module pitch_detection(  
    input clk,  
    input rst,  
    input [7:0] pitch_input,  
    output reg pitch_detected  
);  
    parameter THRESHOLD = 8'd128;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            pitch_detected <= 0;  
        end else begin  
            if (pitch_input > THRESHOLD)  
                pitch_detected <= 1;  
            else  
                pitch_detected <= 0;  
        end  
    end  
endmodule