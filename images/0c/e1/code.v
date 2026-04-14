module deserializer_8bit (  
    input clk,  
    input reset,  
    input serial_in,  
    output reg [7:0] parallel_out,  
    output reg valid  
);  
    reg [2:0] bit_counter;  
  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            bit_counter <= 3'b000;  
            parallel_out <= 8'b00000000;  
            valid <= 0;  
        end else if (bit_counter < 3'b111) begin  
            parallel_out <= {serial_in, parallel_out[7:1]};  
            bit_counter <= bit_counter + 1;  
            valid <= 0;  
        end else begin  
            valid <= 1;  
        end  
    end  
endmodule