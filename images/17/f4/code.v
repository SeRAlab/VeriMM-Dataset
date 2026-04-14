module temp_shutdown(  
    input wire clk,  
    input wire reset,  
    input wire [7:0] temperature,  
    input wire [7:0] threshold,  
    output reg shutdown  
);  

    reg [1:0] count;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            shutdown <= 0;  
            count <= 0;  
        end else begin  
            if (temperature > threshold) begin  
                count <= count + 1;  
                if (count >= 2)  
                    shutdown <= 1;  
            end else begin  
                count <= 0;  
                shutdown <= 0;  
            end  
        end  
    end  
endmodule