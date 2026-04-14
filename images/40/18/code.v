module NoiseSuppression(  
    input [4:0] signal_in,  
    output reg signal_out  
);  
    always @(*) begin  
        if ((signal_in[0] + signal_in[1] + signal_in[2] + signal_in[3] + signal_in[4]) >= 3)  
            signal_out = 1;  
        else  
            signal_out = 0;  
    end  
endmodule