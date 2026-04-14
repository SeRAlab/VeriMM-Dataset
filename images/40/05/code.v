module timer_32bit (  
    input clk,  
    input reset,  
    input start,  
    input stop,  
    input [31:0] max_value,  
    output reg [31:0] count,  
    output reg overflow  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            count <= 32'b0;  
            overflow <= 1'b0;  
        end else if (start && !stop) begin  
            if (count < max_value) begin  
                count <= count + 1;  
                overflow <= 1'b0;  
            end else begin  
                count <= 32'b0;  
                overflow <= 1'b1;  
            end  
        end  
    end  
endmodule