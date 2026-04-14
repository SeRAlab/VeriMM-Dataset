module dram_cell (  
    input wire clk,  
    input wire reset,  
    input wire write_enable,  
    input wire [7:0] data_in,  
    output reg [7:0] data_out  
);  
    reg [7:0] storage;  
    
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            storage <= 8'b0;  
        end else if (write_enable) begin  
            storage <= data_in;  
        end  
    end  
    
    always @(posedge clk) begin  
        if (!write_enable) begin  
            data_out <= storage;  
        end  
    end  
endmodule