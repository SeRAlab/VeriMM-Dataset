module pitch_detector(  
    input clk,  
    input reset,  
    input [7:0] note,  
    output reg detected  
);  

parameter TARGET_PITCH = 8'd60; // Example target pitch (middle C)  

always @(posedge clk or posedge reset) begin  
    if (reset) begin  
        detected <= 0;  
    end else begin  
        if (note == TARGET_PITCH)  
            detected <= 1;  
        else  
            detected <= 0;  
    end  
end  
endmodule