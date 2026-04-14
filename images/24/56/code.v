module dram_cell (  
    input wire clk,  
    input wire rw, // read/write control: 1 for write, 0 for read  
    input wire [3:0] data_in,  
    output reg [3:0] data_out  
);  

    reg [3:0] memory; // 4-bit memory storage  

    always @(posedge clk) begin  
        if (rw)  
            memory <= data_in; // Write data to memory  
        else  
            data_out <= memory; // Read data from memory  
    end  
endmodule