module timer_32bit(  
    input clk,  
    input reset,  
    input [31:0] limit,  
    output reg [31:0] count  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            count <= 32'b0;  
        end else if (count < limit) begin  
            count <= count + 1;  
        end else begin  
            count <= 32'b0;  
        end  
    end  
endmodule