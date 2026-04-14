module divide_by_8(  
    input clk,  
    input reset,  
    output reg out  
);  
    reg [2:0] count;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            count <= 3'b000;  
            out <= 1'b0;  
        end else begin  
            count <= count + 1;  
            if (count == 3'b100) // When count reaches 4  
                out <= 1'b1;  
            else  
                out <= 1'b0;  
        end  
    end  
endmodule