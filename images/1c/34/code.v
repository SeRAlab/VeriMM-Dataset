module deserializer(  
    input clk,  
    input reset,  
    input serial_in,  
    output reg [7:0] parallel_out,  
    output reg data_ready  
);  
    reg [2:0] bit_count;  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            bit_count <= 0;  
            parallel_out <= 8'b0;  
            data_ready <= 0;  
        end else begin  
            if (bit_count < 8) begin  
                parallel_out[bit_count] <= serial_in;  
                bit_count <= bit_count + 1;  
                data_ready <= 0;  
            end  
            if (bit_count == 7) begin  
                data_ready <= 1;  
            end  
        end  
    end  
endmodule