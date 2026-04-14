module dram_cell (  
    input wire [15:0] data_in,  
    input wire write_enable,  
    input wire clk,  
    output reg [15:0] data_out  
);  
    always @(posedge clk) begin  
        if (write_enable)  
            data_out <= data_in;  
    end  
endmodule