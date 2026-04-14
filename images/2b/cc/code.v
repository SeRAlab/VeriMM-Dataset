module zero_crossing_detector (  
    input wire clk,  
    input wire signal_in,  
    output reg zero_crossing_out  
);  
    reg previous_signal;  

    always @(posedge clk) begin  
        if (previous_signal == 1'b0 && signal_in == 1'b1)  
            zero_crossing_out <= 1'b1;  
        else  
            zero_crossing_out <= 1'b0;  

        previous_signal <= signal_in;  
    end  
endmodule