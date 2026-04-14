module timer_8bit(  
    input wire clk,  
    input wire reset,  
    input wire start,  
    input wire [7:0] load_value,  
    output reg [7:0] count,  
    output reg done  
);  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            count <= load_value;  
            done <= 0;  
        end else if (start) begin  
            if (count > 0) begin  
                count <= count - 1;  
                done <= 0;  
            end else begin  
                done <= 1;  
            end  
        end  
    end  
endmodule