module wifi_controller (  
    input wire clk,  
    input wire reset,  
    input wire valid_connection,  
    output reg connected  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            connected <= 0;  
        end else begin  
            if (valid_connection) begin  
                connected <= 1;  
            end else begin  
                connected <= 0;  
            end  
        end  
    end  
endmodule