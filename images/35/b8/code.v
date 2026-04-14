module dynamic_range_compressor (  
    input [9:0] signal_in,  
    output reg [9:0] signal_out  
);  
    parameter THRESHOLD = 10'd512;  
    parameter COMPRESSION_FACTOR = 10'd2;  

    always @(*) begin  
        if (signal_in > THRESHOLD) begin  
            signal_out = signal_in / COMPRESSION_FACTOR;  
        end else begin  
            signal_out = signal_in;  
        end  
    end  
endmodule