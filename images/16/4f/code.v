module carrier_freq_recovery (  
    input wire clk,  
    input wire rst,  
    input wire digital_signal,  
    output reg recovered_signal  
);  
    reg [3:0] phase_accumulator;  
    reg [3:0] phase_error;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            phase_accumulator <= 0;  
            recovered_signal <= 0;  
        end else begin  
            // Simple phase detection logic  
            phase_error <= (digital_signal ^ phase_accumulator[3]);  
            phase_accumulator <= phase_accumulator + phase_error;  
            recovered_signal <= phase_accumulator[3];  
        end  
    end  
endmodule