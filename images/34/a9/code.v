module virtual_memory_management(  
    input clk,  
    input reset,  
    input [3:0] vpn,  // Virtual page number  
    input [3:0] offset, // Offset within the page  
    output reg [7:0] physical_address, // Physical address output  
    output reg error // Error signal  
);  
    // Page table: mapping VPN to PPN  
    reg [3:0] page_table[0:15]; // 16 entries, 4 bits for page number  
    initial begin  
        // Example mappings (VPN to PPN)  
        page_table[0] = 4'b0001;  
        page_table[1] = 4'b0010;  
        page_table[2] = 4'b0011;  
        page_table[3] = 4'b0100;  
        page_table[4] = 4'b0101;  
        page_table[5] = 4'b0000;  
        page_table[6] = 4'b1111;  
        page_table[7] = 4'b1110;  
        page_table[8] = 4'b1101;  
        page_table[9] = 4'b1100;  
        page_table[10] = 4'b1011;  
        page_table[11] = 4'b1010;  
        page_table[12] = 4'b1001;  
        page_table[13] = 4'b1000;  
        page_table[14] = 4'b0111;  
        page_table[15] = 4'b0110;  
    end  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            physical_address <= 8'b0;  
            error <= 1'b1;  
        end else begin  
            if (vpn < 16) begin  
                physical_address <= {page_table[vpn], offset}; // Concatenate PPN and offset  
                error <= 1'b0;  
            end else begin  
                error <= 1'b1; // Invalid VPN  
                physical_address <= 8'b0;  
            end  
        end  
    end  
endmodule