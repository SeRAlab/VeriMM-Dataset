module temp_shutdown(  
    input [3:0] temp,  
    input reset,  
    input clk,  
    output reg shutdown  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            shutdown <= 0;  
        end else begin  
            if (temp > 4'b1111) // 15 in binary is 4'b1111  
                shutdown <= 1;  
            else  
                shutdown <= 0;  
        end  
    end  
endmodule