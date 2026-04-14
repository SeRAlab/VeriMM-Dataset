module wifi_signal_comparator(  
    input [4:0] signal_a,  
    input [4:0] signal_b,  
    output reg [2:0] output_strength  
);  
    always @(*) begin  
        if (signal_a > signal_b)  
            output_strength = 3'b001;  
        else if (signal_a < signal_b)  
            output_strength = 3'b010;  
        else  
            output_strength = 3'b000;  
    end  
endmodule