module current_sensor(  
    input wire clk,  
    input wire [3:0] current_in,  
    output reg alarm_out  
);  
    parameter THRESHOLD = 9;  

    always @(posedge clk) begin  
        if (current_in > THRESHOLD)  
            alarm_out <= 1'b1;  
        else  
            alarm_out <= 1'b0;  
    end  
endmodule