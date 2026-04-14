module counter_32bit (  
    input clk,  
    input reset,  
    input enable,  
    output reg [31:0] count,  
    output reg max_reached  
);  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            count <= 32'b0;  
            max_reached <= 0;  
        end else if (enable) begin  
            if (count == 32'hFFFFFFFF) begin  
                max_reached <= 1;  
                count <= 32'b0; // Wrap around to 0 after reaching max  
            end else begin  
                count <= count + 1;  
                max_reached <= 0;  
            end  
        end  
    end  
endmodule