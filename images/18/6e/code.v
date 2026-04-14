module pitch_detector(input clk, input rst, input [7:0] sample, input [7:0] threshold, output reg detected);  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            detected <= 0;  
        end else begin  
            if (sample > threshold)  
                detected <= 1;  
            else  
                detected <= 0;  
        end  
    end  
endmodule