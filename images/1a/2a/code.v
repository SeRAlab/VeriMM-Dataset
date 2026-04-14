module dma_controller(  
    input wire clk,  
    input wire start_ch1,  
    input wire start_ch2,  
    input wire [7:0] src_addr_ch1,  
    input wire [7:0] dest_addr_ch1,  
    input wire [7:0] src_addr_ch2,  
    input wire [7:0] dest_addr_ch2,  
    output reg busy_ch1,  
    output reg busy_ch2  
);  

    reg [7:0] data_ch1, data_ch2;  

    always @(posedge clk) begin  
        if (start_ch1) begin  
            busy_ch1 <= 1;  
            data_ch1 <= src_addr_ch1;  // Simulate data being read from the source address  
        end  
        else if (busy_ch1) begin  
            // Simulate data transfer  
            busy_ch1 <= 0;  
        end  

        if (start_ch2) begin  
            busy_ch2 <= 1;  
            data_ch2 <= src_addr_ch2;  // Simulate data being read from the source address  
        end  
        else if (busy_ch2) begin  
            // Simulate data transfer  
            busy_ch2 <= 0;  
        end  
    end  
endmodule