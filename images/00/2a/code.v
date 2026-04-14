module temp_shutdown_controller(  
    input wire clk,  
    input wire reset,  
    input wire [7:0] temp,  
    output reg shutdown  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            shutdown <= 0;  
        end else if (temp > 75) begin  
            shutdown <= 1;  
        end  
    end  
endmodule