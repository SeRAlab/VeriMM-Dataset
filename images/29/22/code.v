module edge_detector (  
    input wire clk,  
    input wire rst,  
    input wire signal_in,  
    output reg edge_detected  
);  
    reg signal_in_d; // delayed signal  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            edge_detected <= 0;  
            signal_in_d <= 0;  
        end else begin  
            edge_detected <= (signal_in & ~signal_in_d); // detect rising edge  
            signal_in_d <= signal_in; // store current signal for next cycle  
        end  
    end  
endmodule