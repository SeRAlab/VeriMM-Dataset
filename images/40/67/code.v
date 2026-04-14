module flash_memory_cell (  
    input wire clk,  
    input wire [7:0] data_in,  
    input wire write_enable,  
    input wire erase_enable,  
    output reg [7:0] data_out  
);  
    reg [7:0] memory;  

    always @(posedge clk) begin  
        if (erase_enable) begin  
            memory <= 8'b00000000;  
        end else if (write_enable) begin  
            memory <= data_in;  
        end  
        data_out <= memory;  
    end  
endmodule