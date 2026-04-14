module MMU(clk, reset, virtual_addr, valid, physical_addr);  
    input clk, reset;  
    input [15:0] virtual_addr;  
    output reg valid;  
    output reg [15:0] physical_addr;  

    reg [15:0] page_table [0:15]; // Page table with 16 entries  

    initial begin  
        // Initialize page table (e.g., all pages present)  
        page_table[0] = 16'h0001;  
        page_table[1] = 16'h0002;  
        page_table[2] = 16'h0003;  
        page_table[3] = 16'h0004;  
        page_table[4] = 16'h0005;  
        page_table[5] = 16'h0006;  
        page_table[6] = 16'h0007;  
        page_table[7] = 16'h0008;  
        page_table[8] = 16'h0009;  
        page_table[9] = 16'h000A;  
        page_table[10] = 16'h000B;  
        page_table[11] = 16'h000C;  
        page_table[12] = 16'h000D;  
        page_table[13] = 16'h000E;  
        page_table[14] = 16'h000F;  
        page_table[15] = 16'h0000; // Last page not present  
    end  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            valid <= 0;  
            physical_addr <= 16'h0000;  
        end else begin  
            // Extract page number from the virtual address  
            if (virtual_addr[15:12] < 16) begin  
                if (page_table[virtual_addr[15:12]] != 16'h0000) begin  
                    valid <= 1;  
                    physical_addr <= page_table[virtual_addr[15:12]];  
                end else begin  
                    valid <= 0;  
                    physical_addr <= 16'h0000;  
                end  
            end else begin  
                valid <= 0;  
                physical_addr <= 16'h0000;  
            end  
        end  
    end  
endmodule