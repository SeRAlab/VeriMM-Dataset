module dram_cell(  
    input wire [15:0] data_in,  
    input wire write_enable,  
    input wire clk,  
    output reg [15:0] data_out  
);  
    reg [15:0] storage;  

    always @(posedge clk) begin  
        if (write_enable) begin  
            storage <= data_in;  
        end  
        data_out <= storage;  
    end  
endmodule