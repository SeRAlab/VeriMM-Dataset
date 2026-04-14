module MMU (  
    input wire clk,  
    input wire enable,  
    input wire [11:0] virtual_address,  
    output reg [11:0] physical_address  
);  
    reg [11:0] mapping_table [0:15]; // 16 entries for mapping  
   
    initial begin  
        // Initialize mapping table with example values  
        mapping_table[0] = 12'h000;  
        mapping_table[1] = 12'h001;  
        mapping_table[2] = 12'h002;  
        mapping_table[3] = 12'h003;  
        mapping_table[4] = 12'h004;  
        mapping_table[5] = 12'h005;  
        mapping_table[6] = 12'h006;  
        mapping_table[7] = 12'h007;  
        mapping_table[8] = 12'h008;  
        mapping_table[9] = 12'h009;  
        mapping_table[10] = 12'h00A;  
        mapping_table[11] = 12'h00B;  
        mapping_table[12] = 12'h00C;  
        mapping_table[13] = 12'h00D;  
        mapping_table[14] = 12'h00E;  
        mapping_table[15] = 12'h00F;  
    end  
   
    always @(posedge clk) begin  
        if (enable) begin  
            physical_address <= mapping_table[virtual_address[11:8]];  
        end  
    end  
endmodule