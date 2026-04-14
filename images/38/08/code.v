module mmu(  
    input wire clk,  
    input wire reset,  
    input wire [7:0] logical_address,  
    output reg [7:0] physical_address  
);  
    reg [3:0] page_table [0:15]; // 16 entries in the page table  
    wire [3:0] page_number;  
    wire [3:0] offset;  

    assign page_number = logical_address[7:4];  
    assign offset = logical_address[3:0];  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            physical_address <= 8'b0;  
        end else begin  
            physical_address <= {page_table[page_number], offset};  
        end  
    end  
endmodule