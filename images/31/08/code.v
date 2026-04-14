module dma_controller (  
    input wire clk,  
    input wire start,  
    input wire [7:0] src_addr,  
    input wire [7:0] dst_addr,  
    input wire [15:0] data_in,  
    output reg [15:0] data_out,  
    output reg done  
);  
    reg [7:0] current_src_addr;  
    reg [7:0] current_dst_addr;  
    reg transferring;  

    always @(posedge clk) begin  
        if (start) begin  
            current_src_addr <= src_addr;  
            current_dst_addr <= dst_addr;  
            done <= 0;  
            transferring <= 1;  
        end  
        else if (transferring) begin  
            data_out <= data_in;  
            // Assuming a simple memory model for illustration, we would normally write data to memory here.  
            // For this example, we just consider the transfer done after one clock cycle.  
            transferring <= 0;  
            done <= 1;  
        end  
    end  
endmodule