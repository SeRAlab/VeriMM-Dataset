module rising_edge_detector(  
    input clk,  
    input signal_in,  
    output reg signal_out  
);  
    reg signal_in_d; // Delayed version of the input signal  

    always @(posedge clk) begin  
        signal_in_d <= signal_in;  
        signal_out <= (signal_in && !signal_in_d);  
    end  
endmodule