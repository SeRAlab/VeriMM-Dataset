module current_sensor (  
    input [3:0] current_value,  
    input control_signal,  
    output reg alert  
);  
    reg [3:0] threshold = 4'b0101;  
    always @(posedge control_signal) begin  
        if (current_value > threshold)  
            alert <= 1;  
        else  
            alert <= 0;  
    end  
endmodule