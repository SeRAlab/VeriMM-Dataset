module dram_cell (  
    input wire clk,  
    input wire we,  // write enable  
    input wire re,  // read enable  
    input wire d,   // data input  
    output reg q    // data output  
);  
    reg storage;  // internal storage for the 1-bit  
   
    always @(posedge clk) begin  
        if (we) begin  
            storage <= d;  // write data to storage  
        end  
    end  
   
    always @(posedge clk) begin  
        if (re) begin  
            q <= storage;  // read data from storage  
        end  
    end  
endmodule