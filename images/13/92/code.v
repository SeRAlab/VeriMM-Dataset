module virtual_memory_management (  
    input clk,  
    input [7:0] logical_address,  
    output reg [7:0] physical_address  
);  
    reg [3:0] page_table [0:15]; // Simple page table with 16 entries  
    reg [3:0] page_number;  
    reg [3:0] offset;  

    initial begin  
        // Initialize page table with some values  
        page_table[0] = 4'b0000;  
        page_table[1] = 4'b0001;  
        page_table[2] = 4'b0010;  
        page_table[3] = 4'b0011;  
        page_table[4] = 4'b0100;  
        page_table[5] = 4'b0101;  
        page_table[6] = 4'b0110;  
        page_table[7] = 4'b0111;  
        page_table[8] = 4'b1000;  
        page_table[9] = 4'b1001;  
        page_table[10] = 4'b1010;  
        page_table[11] = 4'b1011;  
        page_table[12] = 4'b1100;  
        page_table[13] = 4'b1101;  
        page_table[14] = 4'b1110;  
        page_table[15] = 4'b1111;  
    end  

    always @(posedge clk) begin  
        page_number = logical_address[7:4];  
        offset = logical_address[3:0];  
        physical_address = {page_table[page_number], offset}; // Concatenate page table entry with offset  
    end  
endmodule