module flash_memory_cell(  
    input wire clk,  
    input wire write_en,  
    input wire read_en,  
    input wire [7:0] data_in,  
    output reg [7:0] data_out  
);  
    always @(posedge clk) begin  
        if (write_en)  
            data_out <= data_in;  
    end  
endmodule