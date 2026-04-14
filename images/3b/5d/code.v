module dvfs_controller(  
    input wire clk,  
    input wire reset,  
    input wire control_signal,  // 1 to increase, 0 to decrease  
    output reg [1:0] frequency,  
    output reg [1:0] voltage  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            frequency <= 2'b00;  // Initial frequency state  
            voltage <= 2'b00;    // Initial voltage state  
        end else begin  
            if (control_signal) begin  
                // Increase both frequency and voltage  
                frequency <= frequency + 1;  
                voltage <= voltage + 1;  
            end else begin  
                // Decrease both frequency and voltage  
                frequency <= frequency - 1;  
                voltage <= voltage - 1;  
            end  
        end  
    end  
endmodule