module MMU (  
    input wire clk,  
    input wire rst,  
    input wire [15:0] virtual_address,  
    output reg [15:0] physical_address  
);  
    // Simple page table for demonstration (10 entries)  
    reg [15:0] page_table [9:0];  
  
    initial begin  
        // Initialize page table with some mappings  
        page_table[0] = 16'h0000; // Virtual page 0 -> Physical frame 0  
        page_table[1] = 16'h1000; // Virtual page 1 -> Physical frame 1  
        page_table[2] = 16'h2000; // Virtual page 2 -> Physical frame 2  
        page_table[3] = 16'h3000; // Virtual page 3 -> Physical frame 3  
        page_table[4] = 16'h4000; // Virtual page 4 -> Physical frame 4  
        page_table[5] = 16'h5000; // Virtual page 5 -> Physical frame 5  
        page_table[6] = 16'h6000; // Virtual page 6 -> Physical frame 6  
        page_table[7] = 16'h7000; // Virtual page 7 -> Physical frame 7  
        page_table[8] = 16'h8000; // Virtual page 8 -> Physical frame 8  
        page_table[9] = 16'h9000; // Virtual page 9 -> Physical frame 9  
    end  
  
    always @(posedge clk or posedge rst) begin  
        if (rst)  
            physical_address <= 16'h0000;  
        else begin  
            // Extract the virtual page number (higher 4 bits)  
            // Assuming the lower 12 bits are the offset within the page  
            physical_address <= page_table[virtual_address[15:12]] | virtual_address[11:0];  
        end  
    end  
endmodule