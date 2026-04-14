module VMU(  
    input clk,  
    input reset,  
    input [9:0] virtual_address,  
    input [31:0] data_in,  
    input read,  
    input write,  
    output reg [31:0] data_out,  
    output reg error  
);  
    reg [9:0] page_table [0:3]; // 4 entries for simplicity  
    reg valid_bits [0:3]; // Valid bits for each page  
    reg [31:0] physical_memory [0:15]; // 16 words of physical memory  
    reg [1:0] page_index;  
    reg [1:0] frame_number;  
    reg [1:0] page_offset;  

    initial begin  
        // Initializing the page table and valid bits  
        page_table[0] = 10'b0000000000; valid_bits[0] = 1;  
        page_table[1] = 10'b0000000100; valid_bits[1] = 1;  
        page_table[2] = 10'b0000001000; valid_bits[2] = 0;  
        page_table[3] = 10'b0000001100; valid_bits[3] = 1;  

        // Initializing physical memory  
        physical_memory[0] = 32'd0;  
        physical_memory[1] = 32'd1;  
        physical_memory[2] = 32'd2;  
        physical_memory[3] = 32'd3;  
        physical_memory[4] = 32'd4;  
        physical_memory[5] = 32'd5;  
        physical_memory[6] = 32'd6;  
        physical_memory[7] = 32'd7;  
        physical_memory[8] = 32'd8;  
        physical_memory[9] = 32'd9;  
        physical_memory[10] = 32'd10;  
        physical_memory[11] = 32'd11;  
        physical_memory[12] = 32'd12;  
        physical_memory[13] = 32'd13;  
        physical_memory[14] = 32'd14;  
        physical_memory[15] = 32'd15;  
    end  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            data_out <= 32'd0;  
            error <= 0;  
        end else begin  
            page_index = virtual_address[9:8];  
            page_offset = virtual_address[7:0];  

            if (valid_bits[page_index]) begin  
                frame_number = page_table[page_index][9:8];  

                if (read) begin  
                    data_out <= physical_memory[{frame_number, page_offset}];  
                    error <= 0;  
                end else if (write) begin  
                    physical_memory[{frame_number, page_offset}] <= data_in;  
                    error <= 0;  
                end  
            end else begin  
                error <= 1;  
            end  
        end  
    end  
endmodule