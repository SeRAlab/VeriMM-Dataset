module timer_32bit (  
    input wire clk,  
    input wire reset,  
    input wire enable,  
    output reg [31:0] count  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            count <= 32'b0;  
        end else if (enable) begin  
            if (count == 32'hFFFFFFFF)  
                count <= 32'b0;  
            else  
                count <= count + 1;  
        end  
    end  
endmodule