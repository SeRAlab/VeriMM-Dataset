module VirtualMemoryManagementUnit (  
    input clk,  
    input reset,  
    input [11:0] logical_address,  
    input read_enable,  
    output reg [11:0] physical_address  
);  
    reg [11:0] page_table [0:15]; // A simple page table with 16 entries  

    // Initializing page table with some values for demonstration  
    initial begin  
        page_table[0] = 12'h000;  
        page_table[1] = 12'h100;  
        page_table[2] = 12'h200;  
        page_table[3] = 12'h300;  
        page_table[4] = 12'h400;  
        page_table[5] = 12'h500;  
        page_table[6] = 12'h600;  
        page_table[7] = 12'h700;  
        page_table[8] = 12'h800;  
        page_table[9] = 12'h900;  
        page_table[10] = 12'hA00;  
        page_table[11] = 12'hB00;  
        page_table[12] = 12'hC00;  
        page_table[13] = 12'hD00;  
        page_table[14] = 12'hE00;  
        page_table[15] = 12'hF00;  
    end  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            physical_address <= 12'h000;  
        end else if (read_enable) begin  
            physical_address <= page_table[logical_address[3:0]]; // Using lower 4 bits for page index  
        end  
    end  
endmodule