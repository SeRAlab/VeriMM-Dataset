module zero_crossing_detector(input signed [7:0] signal_in, output reg zero_cross);  
    always @(*) begin  
        if (signal_in > 0 && signal_in[7] == 0)  
            zero_cross = 1;  
        else if (signal_in <= 0 && signal_in[7] == 1)  
            zero_cross = 0;  
        else  
            zero_cross = zero_cross; // hold previous value  
    end  
endmodule