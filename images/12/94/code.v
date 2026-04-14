module DynamicRangeCompressor(  
    input clk,  
    input rst,  
    input [7:0] in_signal,  
    input control,  
    output reg [7:0] out_signal  
);  
    parameter THRESHOLD = 8'd128;  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            out_signal <= 8'd0;  
        end else begin  
            if (control) begin  
                if (in_signal > THRESHOLD)   
                    out_signal <= THRESHOLD;  
                else  
                    out_signal <= in_signal;  
            end else begin  
                out_signal <= in_signal;  
            end  
        end  
    end  
endmodule