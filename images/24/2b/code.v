module dram_cell (  
    input wire clk,  
    input wire enable,  
    input wire [15:0] data_in,  
    output reg [15:0] data_out  
);  
    reg [15:0] storage;  

    always @(posedge clk) begin  
        if (enable) begin  
            storage <= data_in;  // Write data to cell  
        end  
        data_out <= storage;     // Read data from cell  
    end  
endmodule