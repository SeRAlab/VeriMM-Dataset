module virtual_memory_management (  
    input wire clk,  
    input wire reset,  
    input wire [4:0] virtual_addr,  
    output reg [2:0] physical_addr,  
    output reg valid  
);  

    reg [2:0] page_table [0:31]; // 32 entries for 5-bit virtual address  
    reg [4:0] valid_vaddr;  

    initial begin  
        // Example mappings (virtual page to physical frame)  
        page_table[0] = 3'b000;  
        page_table[1] = 3'b001;  
        page_table[2] = 3'b010;  
        page_table[3] = 3'b011;  
        // Add more mappings as needed  
    end  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            valid <= 0;  
            physical_addr <= 3'bxxx;  
        end else begin  
            valid_vaddr = virtual_addr[4:2]; // Extracting the page number from the virtual address  
            if (valid_vaddr < 32) begin  
                valid <= 1;  
                physical_addr <= page_table[valid_vaddr];  
            end else begin  
                valid <= 0;  
                physical_addr <= 3'bxxx;  
            end  
        end  
    end  
endmodule