module DRAM_Cell(  
    input wire clk,  
    input wire we,      // write enable  
    input wire re,      // read enable  
    input wire d_in,    // data input  
    output reg d_out    // data output  
);  
    reg stored_bit;  
    
    always @(posedge clk) begin  
        if (we) begin  
            stored_bit <= d_in;  
        end  
    end  
    
    always @(posedge clk) begin  
        if (re) begin  
            d_out <= stored_bit;  
        end  
    end  
endmodule