module deserializer_16bit (  
    input wire clk,  
    input wire serial_in,  
    output reg [15:0] parallel_out,  
    output reg data_ready  
);  
    reg [3:0] bit_count;  

    always @(posedge clk) begin  
        if (bit_count < 16) begin  
            parallel_out <= {parallel_out[14:0], serial_in};  
            bit_count <= bit_count + 1;  
        end  
        if (bit_count == 15) begin  
            data_ready <= 1;  
        end else begin  
            data_ready <= 0;  
        end  
    end  

    initial begin  
        bit_count = 0;  
        parallel_out = 0;  
        data_ready = 0;  
    end  
endmodule