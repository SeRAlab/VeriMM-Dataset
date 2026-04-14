module deserializer_8bit (  
    input wire clk,  
    input wire reset,  
    input wire serial_in,  
    output reg [7:0] parallel_out  
);  
    reg [2:0] bit_count; // 3 bits to count up to 8  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            parallel_out <= 8'b0;  
            bit_count <= 3'b0;  
        end else if (bit_count < 3'd8) begin  
            parallel_out <= {serial_in, parallel_out[7:1]};  
            bit_count <= bit_count + 1;  
        end  
    end  
endmodule