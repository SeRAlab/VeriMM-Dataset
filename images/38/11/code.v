module deserializer_8bit (  
    input wire clk,  
    input wire reset,  
    input wire serial_in,  
    output reg [7:0] parallel_out  
);  
    reg [2:0] bit_count; // 3 bits to count from 0 to 7  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            bit_count <= 3'b000;  
            parallel_out <= 8'b00000000;  
        end else begin  
            if (bit_count < 3'b111) begin  
                parallel_out <= {parallel_out[6:0], serial_in}; // Shift in serial data  
                bit_count <= bit_count + 1;  
            end  
        end  
    end  
endmodule