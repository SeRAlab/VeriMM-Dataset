module zero_crossing_detector(input signed [15:0] signal, output reg zero_cross);  
    always @(*) begin  
        if (signal > 0)  
            zero_cross = 1;  
        else if (signal < 0)  
            zero_cross = 0;  
        else  
            zero_cross = zero_cross; // Hold previous value  
    end  
endmodule