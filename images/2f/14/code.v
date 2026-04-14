module SRAM16Bit (  
    input wire [15:0] data_in,  
    input wire write_enable,  
    output reg [15:0] data_out  
);  
    always @(posedge write_enable) begin  
        if (write_enable)  
            data_out <= data_in;  
    end  
endmodule