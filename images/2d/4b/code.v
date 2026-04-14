module mmu(  
    input [7:0] virtual_address,  
    output reg [7:0] physical_address,  
    output reg page_fault  
);  
    reg [3:0] page_table [0:15]; // Simple page table with 16 entries  
    initial begin  
        // Initialize page table with some values  
        page_table[0] = 8'h01;  
        page_table[1] = 8'h02;  
        page_table[2] = 8'h03;  
        page_table[3] = 8'h04;  
        page_table[4] = 8'h05;  
        page_table[5] = 8'h06;  
        page_table[6] = 8'h07;  
        page_table[7] = 8'h08;  
        page_table[8] = 8'h09;  
        page_table[9] = 8'h0A;  
        page_table[10] = 8'h0B;  
        page_table[11] = 8'h0C;  
        page_table[12] = 8'h0D;  
        page_table[13] = 8'h0E;  
        page_table[14] = 8'h0F;  
        page_table[15] = 8'h00;  
    end  

    always @(*) begin  
        page_fault = 0;  
        if (virtual_address[7:4] < 16) begin // Check if page number is valid  
            physical_address = {page_table[virtual_address[7:4]], virtual_address[3:0]};  
        end else begin  
            page_fault = 1; // Page fault occurred  
            physical_address = 8'h00; // Set to invalid address  
        end  
    end  
endmodule