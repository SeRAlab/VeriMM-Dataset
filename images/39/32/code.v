module serializer_16bit(  
    input wire clk,  
    input wire reset,  
    input wire valid,  
    input wire [15:0] data_in,  
    output reg serial_out,  
    output reg [3:0] bit_counter  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            serial_out <= 0;  
            bit_counter <= 0;  
        end else if (valid) begin  
            if (bit_counter < 16) begin  
                serial_out <= data_in[15 - bit_counter];  
                bit_counter <= bit_counter + 1;  
            end else begin  
                bit_counter <= 0;  
            end  
        end  
    end  
endmodule