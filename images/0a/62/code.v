module vmu(  
    input wire clk,  
    input wire [1:0] virtual_page,  
    input wire valid,  
    output reg [3:0] physical_address,  
    output reg error  
);  
    reg [1:0] page_table [0:3]; // Mapping from virtual page to physical frame  
    initial begin  
        // Example page table initialization  
        page_table[0] = 2'b00; // Virtual page 0 -> Physical frame 0  
        page_table[1] = 2'b01; // Virtual page 1 -> Physical frame 1  
        page_table[2] = 2'b10; // Virtual page 2 -> Physical frame 2  
        page_table[3] = 2'b11; // Virtual page 3 -> Physical frame 3  
    end  

    always @(posedge clk) begin  
        if (valid) begin  
            physical_address <= {page_table[virtual_page], 2'b00}; // Convert to physical address  
            error <= 0;  
        end else begin  
            physical_address <= 4'b0000;  
            error <= 1; // Set error signal if entry is not valid  
        end  
    end  
endmodule