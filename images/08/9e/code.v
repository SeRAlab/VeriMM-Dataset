module divide_by_8(  
    input wire clk,  
    input wire reset,  
    output reg out  
);  
    reg [2:0] count; // 3-bit counter for counts from 0 to 7  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            count <= 3'b000;  
            out <= 1'b0;  
        end else begin  
            if (count == 3'b111) begin  
                count <= 3'b000;  
                out <= ~out; // Toggle the output  
            end else begin  
                count <= count + 1;  
            end  
        end  
    end  
endmodule