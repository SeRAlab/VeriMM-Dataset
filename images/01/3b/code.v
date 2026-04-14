module dram_cell (  
    input wire clk,  
    input wire we,   // Write Enable  
    input wire re,   // Read Enable  
    input wire d,    // Data input  
    output reg q     // Data output  
);  
    reg stored_bit;  
   
    always @(posedge clk) begin  
        if (we) begin  
            stored_bit <= d;  
        end  
    end  
   
    always @(posedge clk) begin  
        if (re) begin  
            q <= stored_bit;  
        end  
    end  
endmodule