module dma_controller (  
    input wire clk,  
    input wire rst,  
    input wire start_channel1,  
    input wire start_channel2,  
    input wire [7:0] src_addr1,  
    input wire [7:0] dest_addr1,  
    input wire [7:0] src_addr2,  
    input wire [7:0] dest_addr2,  
    output reg busy_channel1,  
    output reg busy_channel2  
);  

    reg [7:0] src_reg1, dest_reg1;  
    reg [7:0] src_reg2, dest_reg2;  
   
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            busy_channel1 <= 0;  
            busy_channel2 <= 0;  
        end else begin  
            if (start_channel1 && !busy_channel1) begin  
                src_reg1 <= src_addr1;  
                dest_reg1 <= dest_addr1;  
                busy_channel1 <= 1;  
            end  
            if (start_channel2 && !busy_channel2) begin  
                src_reg2 <= src_addr2;  
                dest_reg2 <= dest_addr2;  
                busy_channel2 <= 1;  
            end  
            // Simulate data transfer completion  
            if (busy_channel1) begin  
                busy_channel1 <= 0;  // Complete transfer for channel 1  
            end  
            if (busy_channel2) begin  
                busy_channel2 <= 0;  // Complete transfer for channel 2  
            end  
        end  
    end  
endmodule