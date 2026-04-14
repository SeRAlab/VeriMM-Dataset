module pulse_generator(  
    input clk,  
    input [3:0] pulse_width,  
    input [3:0] frequency,  
    output reg pulse_out  
);  
    reg [3:0] counter;  
    reg [3:0] pulse_counter;  
    reg pulse_active;  
    always @(posedge clk) begin  
        if (counter == frequency) begin  
            counter <= 0;  
            pulse_active <= 1;  
            pulse_counter <= 0;  
        end else begin  
            counter <= counter + 1;  
        end  

        if (pulse_active) begin  
            if (pulse_counter < pulse_width) begin  
                pulse_out <= 1;  
                pulse_counter <= pulse_counter + 1;  
            end else begin  
                pulse_out <= 0;  
                pulse_active <= 0;  
            end  
        end else begin  
            pulse_out <= 0;  
        end  
    end  
endmodule