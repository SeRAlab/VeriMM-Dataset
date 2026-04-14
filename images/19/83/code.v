module EchoCancellation #(parameter CANCELLATION_FACTOR = 8) (  
    input clk,  
    input rst,  
    input [15:0] audio_in,  
    input [15:0] reference_in,  
    output reg [15:0] audio_out  
);  
    reg [15:0] delayed_reference;  
   
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            audio_out <= 16'd0;  
            delayed_reference <= 16'd0;  
        end else begin  
            delayed_reference <= reference_in;  
            audio_out <= audio_in - (delayed_reference / CANCELLATION_FACTOR);  
        end  
    end  
endmodule