module divide_by_8 (  
    input clk,  
    input reset,  
    input enable,  
    output reg out  
);  
    reg [2:0] counter;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            counter <= 3'b000;  
            out <= 0;  
        end  
        else if (enable) begin  
            if (counter == 3'b111) begin  
                counter <= 3'b000;  
                out <= 1;  
            end  
            else begin  
                counter <= counter + 1;  
                out <= 0;  
            end  
        end  
    end  
endmodule