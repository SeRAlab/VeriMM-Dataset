module zero_crossing_detector(  
    input wire clk,  
    input wire reset,  
    input wire signal_in,  
    output reg zero_crossed  
);  
    reg signal_in_prev;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            zero_crossed <= 0;  
            signal_in_prev <= 0;  
        end else begin  
            if ((signal_in_prev == 0) && (signal_in == 1)) begin  
                zero_crossed <= 1;  
            end else begin  
                zero_crossed <= 0;  
            end  
            signal_in_prev <= signal_in;  
        end  
    end  
endmodule