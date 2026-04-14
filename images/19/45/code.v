module zero_crossing_detector(  
    input clk,  
    input rst,  
    input signal_in,  
    output reg zero_crossing_out  
);  

reg previous_signal;  

always @(posedge clk or posedge rst) begin  
    if (rst) begin  
        zero_crossing_out <= 0;  
        previous_signal <= 0;  
    end else begin  
        zero_crossing_out <= (previous_signal ^ signal_in);  
        previous_signal <= signal_in;  
    end  
end  
endmodule