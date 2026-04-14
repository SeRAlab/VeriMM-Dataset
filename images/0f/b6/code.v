module deserializer(  
    input clk,  
    input reset,  
    input serial_in,  
    output reg [7:0] parallel_out,  
    output reg valid  
);  
    reg [2:0] bit_count;  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            bit_count <= 3'b000;  
            parallel_out <= 8'b00000000;  
            valid <= 1'b0;  
        end else begin  
            if (bit_count < 3'b111) begin  
                parallel_out <= {serial_in, parallel_out[7:1]};  
                bit_count <= bit_count + 1;  
                valid <= 1'b0;  
            end else begin  
                valid <= 1'b1;  
                bit_count <= 3'b000;  
            end  
        end  
    end  
endmodule