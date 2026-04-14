module temp_shutdown (  
    input wire [3:0] temperature,  
    input wire reset,  
    input wire clk,  
    output reg shutdown  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset)  
            shutdown <= 0;  
        else if (temperature > 4'b1010)  
            shutdown <= 1;  
        else  
            shutdown <= 0;  
    end  
endmodule