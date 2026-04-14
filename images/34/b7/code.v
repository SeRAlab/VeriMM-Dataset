module divide_by_4 (  
    input clk,  
    input reset,  
    output reg out  
);  
    reg [1:0] count;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            count <= 2'b00;  
            out <= 0;  
        end else begin  
            count <= count + 1;  
            if (count == 2'b11) begin  
                out <= 1;  
            end else begin  
                out <= 0;  
            end  
        end  
    end  
endmodule