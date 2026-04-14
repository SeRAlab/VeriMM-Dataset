module temperature_shutdown (  
    input wire clk,  
    input wire [7:0] temperature,  
    output reg shutdown  
);  
    reg temp_exceeds_threshold;  

    always @(posedge clk) begin  
        if (temperature > 75)  
            temp_exceeds_threshold <= 1;  
        else if (temperature < 70)  
            temp_exceeds_threshold <= 0;  
    end  

    always @(posedge clk) begin  
        if (temp_exceeds_threshold)  
            shutdown <= 1;  
        else  
            shutdown <= 0;  
    end  
endmodule