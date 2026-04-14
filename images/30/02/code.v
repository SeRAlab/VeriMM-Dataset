module temp_shutdown_controller(  
    input clk,  
    input reset,  
    input [7:0] temp,  
    output reg shutdown  
);  
    parameter THRESHOLD = 8'd80;  
    reg overheat;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            shutdown <= 0;  
            overheat <= 0;  
        end else begin  
            if (temp > THRESHOLD) begin  
                overheat <= 1;  
            end else if (temp <= THRESHOLD) begin  
                overheat <= 0;  
            end  
            shutdown <= overheat;  
        end  
    end  
endmodule