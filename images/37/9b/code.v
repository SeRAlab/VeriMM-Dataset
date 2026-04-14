module mmu(input clk,  
            input rst,  
            input [9:0] virtual_address,  
            input w_enable,  
            output reg [9:0] physical_address,  
            output reg page_fault);  
            
    reg [9:0] page_table [0:3]; // A simple page table with 4 entries  
    reg [1:0] page_index;  
    
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            physical_address <= 10'b0;  
            page_fault <= 1'b0;  
            // Initialize page table  
            page_table[0] <= 10'b0000000000; // Page 0  
            page_table[1] <= 10'b0000000001; // Page 1  
            page_table[2] <= 10'b0000000010; // Page 2  
            page_table[3] <= 10'b0000000011; // Page 3  
        end else begin  
            page_index = virtual_address[9:8]; // Assume 2 bits for page index  
            if (page_index < 4) begin  
                physical_address <= page_table[page_index] + virtual_address[7:0];  
                page_fault <= 1'b0;  
            end else begin  
                page_fault <= 1'b1; // Page fault  
            end  
        end  
    end  
endmodule