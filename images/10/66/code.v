module edge_detector(  
    input wire clk,  
    input wire rst,  
    input wire signal,  
    output reg edge_detected  
);  

    reg signal_d;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            edge_detected <= 0;  
            signal_d <= 0;  
        end else begin  
            edge_detected <= (signal && !signal_d);  
            signal_d <= signal;  
        end  
    end  
endmodule