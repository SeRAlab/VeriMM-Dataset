module vm_address_translation (  
    input wire clk,  
    input wire reset,  
    input wire [31:0] virtual_address,  
    output reg [31:0] physical_address,  
    output reg valid  
);  
    reg [31:0] page_table [0:255]; // Simple page table with 256 entries  
    reg [7:0] page_number;  
    reg [23:0] offset;  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            valid <= 0;  
            physical_address <= 32'b0;  
        end else begin  
            page_number <= virtual_address[31:24]; // 8 bits for page number  
            offset <= virtual_address[23:0]; // 24 bits for offset  
            physical_address <= page_table[page_number] + offset;  
            valid <= 1; // Assume valid for this simple example  
        end  
    end  
endmodule