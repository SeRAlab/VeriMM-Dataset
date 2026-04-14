module temp_shutdown (  
    input wire clk,  
    input wire reset,  
    input wire [7:0] temperature,  
    output reg shutdown  
);  
    parameter THRESHOLD = 8'd80; // Shutdown threshold  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            shutdown <= 1'b0;  
        end else begin  
            if (temperature > THRESHOLD) begin  
                shutdown <= 1'b1;  
            end else begin  
                shutdown <= 1'b0;  
            end  
        end  
    end  
endmodule