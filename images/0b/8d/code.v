module virtual_memory_management (  
    input wire clk,  
    input wire reset,  
    input wire [7:0] virtual_address,  
    input wire read_write, // 0 for read, 1 for write  
    output reg [7:0] physical_address,  
    output reg page_fault  
);  
    reg [7:0] page_table [0:15]; // Simple page table with 16 entries  
    reg [3:0] virtual_page;  
    reg [7:0] offset;  
   
    initial begin  
        // Initialize page table with some values  
        page_table[0] = 8'h00;  
        page_table[1] = 8'h01;  
        page_table[2] = 8'h02;  
        page_table[3] = 8'h03;  
        page_table[4] = 8'h04;  
        page_table[5] = 8'h05;  
        page_table[6] = 8'h06;  
        page_table[7] = 8'h07;  
        page_table[8] = 8'h08;  
        page_table[9] = 8'h09;  
        page_table[10] = 8'h0A;  
        page_table[11] = 8'h0B;  
        page_table[12] = 8'h0C;  
        page_table[13] = 8'h0D;  
        page_table[14] = 8'h0E;  
        page_table[15] = 8'h0F;  
    end  
   
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            physical_address <= 8'h00;  
            page_fault <= 1'b0;  
        end else begin  
            virtual_page <= virtual_address[7:4];  
            offset <= virtual_address[3:0];  
            if (virtual_page < 16) begin  
                physical_address <= {page_table[virtual_page], offset};  
                page_fault <= 1'b0;  
            end else begin  
                page_fault <= 1'b1;  
            end  
        end  
    end  
endmodule