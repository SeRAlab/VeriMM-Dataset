module pitch_detector(  
    input clk,  
    input reset,  
    input enable,  
    input [11:0] frequency, // 12-bit frequency input  
    output reg in_range // Output signal  
);  
    parameter MIN_FREQ = 12'd100; // Minimum frequency threshold  
    parameter MAX_FREQ = 12'd1000; // Maximum frequency threshold  
  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            in_range <= 0;  
        end else if (enable) begin  
            if (frequency >= MIN_FREQ && frequency <= MAX_FREQ)  
                in_range <= 1;  
            else  
                in_range <= 0;  
        end  
    end  
endmodule