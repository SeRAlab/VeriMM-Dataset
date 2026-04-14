module vco(  
    input wire clk,  
    input wire enable,  
    input wire [3:0] control_voltage,  
    output reg frequency_out  
);  
    reg [7:0] counter;  
    reg [7:0] threshold;  

    always @(posedge clk) begin  
        if (enable) begin  
            threshold <= control_voltage * 16; // Scale the control voltage  
            if (counter < threshold) begin  
                frequency_out <= 1;  
            end else begin  
                frequency_out <= 0;  
            end  
            counter <= counter + 1;  
            if (counter >= 255) begin  
                counter <= 0;  
            end  
        end else begin  
            frequency_out <= 0;  
            counter <= 0;  
        end  
    end  
endmodule