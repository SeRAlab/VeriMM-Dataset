module deserializer_8bit (
    input wire clk,
    input wire reset,
    input wire serial_in,
    output reg [7:0] parallel_out,
    output reg data_ready
);  
    reg [2:0] bit_count;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            bit_count <= 3'b000;  
            parallel_out <= 8'b0;  
            data_ready <= 1'b0;  
        end else begin  
            if (bit_count < 3'b111) begin  
                parallel_out <= {serial_in, parallel_out[7:1]};  
                bit_count <= bit_count + 1;  
                data_ready <= 1'b0;  
            end else begin  
                data_ready <= 1'b1;  
            end  
        end  
    end  
endmodule