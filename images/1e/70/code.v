module sample_rate_converter(  
    input clk,  
    input rst,  
    input [15:0] audio_in,  
    output reg [15:0] audio_out  
);  
    reg [15:0] last_sample;  
    reg [1:0] counter;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            last_sample <= 16'b0;  
            audio_out <= 16'b0;  
            counter <= 2'b0;  
        end else begin  
            if (counter == 2'b00) begin  
                audio_out <= audio_in;  
                last_sample <= audio_in;  
                counter <= counter + 1;  
            end else begin  
                audio_out <= last_sample;  
                counter <= 2'b00;  
            end  
        end  
    end  
endmodule