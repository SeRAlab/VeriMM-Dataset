module dynamic_range_compressor (  
    input [4:0] in_signal,  
    output reg [2:0] out_signal  
);  
    always @(*) begin  
        if (in_signal <= 5'd3) begin  
            out_signal = in_signal[2:0];  
        end else if (in_signal <= 5'd12) begin  
            out_signal = in_signal - 5'd3;  
            if (out_signal > 3'd7) begin  
                out_signal = 3'd7;  
            end  
        end else begin  
            out_signal = 3'd7;  
        end  
    end  
endmodule