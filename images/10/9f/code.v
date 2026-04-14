module dram_cell (  
    input clk,  
    input rst,  
    input [15:0] data_in,  
    input write_en,  
    input read_en,  
    output reg [15:0] data_out,  
    output reg refresh  
);  
    reg [15:0] memory;  
    reg [6:0] cycle_count;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            memory <= 16'b0;  
            cycle_count <= 7'b0;  
            refresh <= 1'b0;  
        end else begin  
            if (write_en) begin  
                memory <= data_in;  
            end  
            if (read_en) begin  
                data_out <= memory;  
            end  
            cycle_count <= cycle_count + 1;  
            if (cycle_count == 100) begin  
                refresh <= 1'b1;  
                cycle_count <= 7'b0;  
            end else begin  
                refresh <= 1'b0;  
            end  
        end  
    end  
endmodule