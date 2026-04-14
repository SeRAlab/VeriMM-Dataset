module dram_cell (  
    input wire clk,  
    input wire write_en,  
    input wire [3:0] data_in,  
    output reg [3:0] data_out  
);  
    reg [3:0] storage;  

    always @(posedge clk) begin  
        if (write_en) begin  
            storage <= data_in;  
        end  
        data_out <= storage;  
    end  
endmodule