module sram_cell (  
    input wire [7:0] data_in,  
    input wire [2:0] addr,  
    input wire read_en,  
    input wire write_en,  
    input wire clk,  
    output reg [7:0] data_out  
);  

    reg [7:0] mem [0:7];  // 8 locations of 8 bits each  

    always @(posedge clk) begin  
        if (write_en) begin  
            mem[addr] <= data_in;  // Write data to memory  
        end  
    end  

    always @(posedge clk) begin  
        if (read_en) begin  
            data_out <= mem[addr];  // Read data from memory  
        end  
    end  
endmodule