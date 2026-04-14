module zero_crossing_detector(  
    input wire clk,  
    input wire signal_in,  
    output reg zero_crossing_out  
);  
    reg signal_in_prev;  

    always @(posedge clk) begin  
        zero_crossing_out <= (signal_in_prev && !signal_in) || (!signal_in_prev && signal_in);  
        signal_in_prev <= signal_in;  
    end  
endmodule