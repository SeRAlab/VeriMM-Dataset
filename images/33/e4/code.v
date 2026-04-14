module deserializer(  
    input wire clk,  
    input wire reset,  
    input wire serial_in,  
    output reg [7:0] parallel_out,  
    output reg data_valid  
);  
    reg [2:0] bit_count;  // Count the number of bits received  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            parallel_out <= 8'b0;  
            bit_count <= 3'b0;  
            data_valid <= 1'b0;  
        end else begin  
            if (bit_count < 3'd8) begin  
                parallel_out <= {serial_in, parallel_out[7:1]};  
                bit_count <= bit_count + 1;  
            end  
            if (bit_count == 3'd7) begin  
                data_valid <= 1'b1;  
            end else begin  
                data_valid <= 1'b0;  
            end  
        end  
    end  
endmodule