module dram_cell(  
    input wire clk,  
    input wire we,  // Write Enable  
    input wire word_line,  
    input wire bit_in,  
    output reg bit_out  
);  
    reg stored_bit;  // Represents the stored bit in the DRAM cell  

    always @(posedge clk) begin  
        if (word_line) begin  
            if (we) begin  
                stored_bit <= bit_in;  // Write operation  
            end  
            bit_out <= stored_bit;  // Read operation  
        end  
    end  
endmodule