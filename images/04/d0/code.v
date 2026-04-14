module dma_controller(input clk, input rst, input start, input [7:0] src_addr, input [7:0] dest_addr, input [3:0] byte_count, output reg done);  
    reg [3:0] count;  
    reg [7:0] src, dest;  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            done <= 0;  
            count <= 0;  
        end  
        else if (start && count == 0) begin  
            src <= src_addr;  
            dest <= dest_addr;  
            count <= byte_count;  
        end  
        else if (count > 0) begin  
            // Simulate data transfer (In actual implementation, data transfer logic would go here)  
            count <= count - 1;  
            if (count == 1)  
                done <= 1;  
        end  
    end  
endmodule