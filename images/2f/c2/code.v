module dma_controller (  
    input clk,  
    input reset,  
    input start,  
    input [7:0] src_addr,  
    input [7:0] dest_addr,  
    input [3:0] data_size,  
    output reg done  
);  
    reg [3:0] count;  
    reg transferring;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            done <= 0;  
            count <= 0;  
            transferring <= 0;  
        end else if (start && !transferring) begin  
            transferring <= 1;  
            count <= 0;  
            done <= 0;  
        end else if (transferring) begin  
            if (count < data_size) begin  
                // Simulate data transfer logic here  
                count <= count + 1;  
            end else begin  
                transferring <= 0;  
                done <= 1;  
            end  
        end  
    end  
endmodule