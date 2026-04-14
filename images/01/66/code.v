module temperature_shutdown(  
    input wire clk,  
    input wire reset,  
    input wire [7:0] temp,  
    output reg shutdown  
);  
    parameter THRESHOLD = 8'd75;  

    always @(posedge clk or posedge reset) begin  
        if (reset)  
            shutdown <= 1'b0;  
        else if (temp > THRESHOLD)  
            shutdown <= 1'b1;  
        else  
            shutdown <= 1'b0;  
    end  
endmodule