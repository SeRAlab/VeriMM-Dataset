module pitch_detection(clk, reset, signal_in, pitch_out);  
    input clk;  
    input reset;  
    input signal_in;  
    output reg [15:0] pitch_out;  

    reg [15:0] zero_crossings;  
    reg [23:0] count;  
    reg last_signal;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            zero_crossings <= 0;  
            count <= 0;  
            pitch_out <= 0;  
            last_signal <= 0;  
        end else begin  
            count <= count + 1;  
            if (last_signal ^ signal_in) begin  
                zero_crossings <= zero_crossings + 1;  
            end  
            last_signal <= signal_in;  

            // Assuming this block runs every 1 second to output frequency  
            if (count == 24'd1000000) begin  
                pitch_out <= zero_crossings;  
                zero_crossings <= 0;  
                count <= 0;  
            end  
        end  
    end  
endmodule