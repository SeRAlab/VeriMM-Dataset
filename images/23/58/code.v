module deserializer (  
    input wire clk,  
    input wire valid,  
    input wire serial_in,  
    output reg [7:0] parallel_out,  
    output reg data_ready  
);  
    reg [2:0] bit_count;  

    always @(posedge clk) begin  
        if (valid) begin  
            parallel_out <= {parallel_out[6:0], serial_in};  
            bit_count <= bit_count + 1;  
            if (bit_count == 7) begin  
                data_ready <= 1;  
                bit_count <= 0;  
            end else begin  
                data_ready <= 0;  
            end  
        end  
    end  
endmodule