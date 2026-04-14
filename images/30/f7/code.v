module VirtualMemoryManagement(  
    input wire [7:0] virtual_address,  
    input wire valid,  
    output reg [7:0] physical_address,  
    output reg error  
);  
    // Define a simple page table with 4 entries  
    reg [7:0] page_table [0:3];  

    initial begin  
        // Initialize the page table  
        page_table[0] = 8'h10; // Page 0  
        page_table[1] = 8'h20; // Page 1  
        page_table[2] = 8'h30; // Page 2  
        page_table[3] = 8'h40; // Page 3  
    end  

    always @(virtual_address or valid) begin  
        if (valid) begin  
            // Assuming lower 2 bits of virtual_address are the page index  
            physical_address = page_table[virtual_address[1:0]];  
            error = 0;  
        end else begin  
            physical_address = 8'h00;  
            error = 1;  
        end  
    end  
endmodule