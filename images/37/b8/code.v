module PageTable (  
    input wire clk,  
    input wire we,  
    input wire [3:0] v_addr,  
    input wire [3:0] frame_num,  
    output reg [3:0] p_frame  
);  
    reg [3:0] page_table [0:15];  // Page table with 16 entries  

    always @(posedge clk) begin  
        if (we) begin  
            page_table[v_addr] <= frame_num;  // Write frame number to page table  
        end  
        p_frame <= page_table[v_addr];  // Read frame number from page table  
    end  
endmodule