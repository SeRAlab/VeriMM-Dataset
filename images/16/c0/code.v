module serializer_32bit(  
    input wire clk,  
    input wire enable,  
    input wire [31:0] data_in,  
    output reg serial_out  
);  
    reg [4:0] bit_index;  

    always @(posedge clk) begin  
        if (enable) begin  
            if (bit_index < 32) begin  
                serial_out <= data_in[31 - bit_index];  
                bit_index <= bit_index + 1;  
            end  
        end  
        else begin  
            bit_index <= 0;  
            serial_out <= serial_out;  
        end  
    end  

    initial begin  
        bit_index = 0;  
        serial_out = 0;  
    end  
endmodule