module sram_cell (  
    input wire [7:0] data_in,  
    input wire write_enable,  
    input wire clk,  
    output reg [7:0] data_out,  
    output reg valid  
);  

    always @(posedge clk) begin  
        if (write_enable) begin  
            data_out <= data_in;  
            valid <= 1;  
        end else begin  
            valid <= 0;  
        end  
    end  
endmodule