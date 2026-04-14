module virtual_memory_management (  
    input wire clk,  
    input wire reset,  
    input wire [1:0] page_number,  
    input wire [3:0] frame_number,  
    input wire valid,  
    input wire dirty,  
    input wire read_write, // 0 for read, 1 for write  
    output reg [3:0] memory_out,  
    output reg page_fault  
);  
    reg [3:0] page_table [0:3]; // Page table with 4 entries  
    reg valid_bits [0:3];  
    reg dirty_bits [0:3];  

    initial begin  
        page_fault = 0;  
        memory_out = 0;  
        // Initialize page table entries  
        page_table[0] = 4'b0000; valid_bits[0] = 0; dirty_bits[0] = 0;  
        page_table[1] = 4'b0001; valid_bits[1] = 0; dirty_bits[1] = 0;  
        page_table[2] = 4'b0010; valid_bits[2] = 0; dirty_bits[2] = 0;  
        page_table[3] = 4'b0011; valid_bits[3] = 0; dirty_bits[3] = 0;  
    end  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            page_fault <= 0;  
            memory_out <= 0;  
        end else begin  
            if (valid_bits[page_number]) begin  
                // Page is valid, perform read/write  
                if (read_write) begin  
                    // Write operation  
                    memory_out <= frame_number;  
                    dirty_bits[page_number] <= 1;  
                end else begin  
                    // Read operation  
                    memory_out <= page_table[page_number];  
                end  
            end else begin  
                // Page fault  
                page_fault <= 1;  
                // Load the page into memory (For simplicity, just assign frame number)  
                page_table[page_number] <= frame_number;  
                valid_bits[page_number] <= valid;  
                dirty_bits[page_number] <= dirty;  
                memory_out <= frame_number;  
            end  
        end  
    end  
endmodule