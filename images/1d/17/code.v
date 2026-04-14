module serializer_16bit (  
    input wire clk,  
    input wire reset,  
    input wire [15:0] parallel_in,  
    output reg serial_out  
);  
    reg [3:0] bit_count;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            bit_count <= 0;  
            serial_out <= 0;  
        end else begin  
            if (bit_count < 16) begin  
                serial_out <= parallel_in[15 - bit_count];  
                bit_count <= bit_count + 1;  
            end  
        end  
    end  
endmodule