module VirtualMemoryManagement(input clk, input reset, input [7:0] virtual_address, output reg [7:0] physical_address, output reg page_fault);  
  reg [7:0] page_table [0:3]; // Simple page table with 4 entries  
  reg [1:0] page_index;  
  reg [7:0] base_address;  
  
  initial begin  
    // Initialize the page table with some example values  
    page_table[0] = 8'h00; // Page 0 maps to physical address 0  
    page_table[1] = 8'h10; // Page 1 maps to physical address 16  
    page_table[2] = 8'h20; // Page 2 maps to physical address 32  
    page_table[3] = 8'hFF; // Page 3 is not allocated - causes page fault  
  end  
  
  always @(posedge clk or posedge reset) begin  
    if (reset) begin  
      physical_address <= 8'h00;  
      page_fault <= 1'b0;  
    end else begin  
      page_index = virtual_address[7:6]; // Get the page index from the virtual address  
      if (page_index < 4) begin  
        base_address = page_table[page_index];  
        if (base_address == 8'hFF) begin // Page fault condition  
          page_fault <= 1'b1;  
          physical_address <= 8'h00; // In case of page fault, output a default address  
        end else begin  
          page_fault <= 1'b0;  
          physical_address <= base_address + virtual_address[5:0]; // Calculate physical address  
        end  
      end else begin  
        page_fault <= 1'b1; // Invalid page index (out of bounds)  
        physical_address <= 8'h00;  
      end  
    end  
  end  
endmodule