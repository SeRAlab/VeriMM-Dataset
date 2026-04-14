module iir_filter (  
    input clk,  
    input rst,  
    input signed [15:0] input_sample,  
    output reg signed [15:0] output_sample  
);  
    reg signed [15:0] previous_output;  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            previous_output <= 16'sd0;  
            output_sample <= 16'sd0;  
        end else begin  
            output_sample <= (input_sample >>> 2) + (previous_output >>> 1);  // Use shifting for division by 4 and 2  
            previous_output <= output_sample;  
        end  
    end  
endmodule