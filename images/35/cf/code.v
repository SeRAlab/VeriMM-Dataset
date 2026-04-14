module dma_controller (  
    input wire clk,  
    input wire reset,  
    input wire enable,  
    input wire [7:0] src_addr,  
    input wire [7:0] dest_addr,  
    inout wire [7:0] data_bus  
);  
    reg [7:0] memory [0:255];  
    reg [7:0] data_out;  
    reg data_valid;  
  
    assign data_bus = data_valid ? data_out : 8'bz;  
  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            data_valid <= 0;  
        end else if (enable) begin  
            data_out <= memory[src_addr];  
            data_valid <= 1;  
            memory[dest_addr] <= data_out;  
        end else begin  
            data_valid <= 0;  
        end  
    end  
endmodule