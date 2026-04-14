module serializer32 (  
    input clk,  
    input reset,  
    input [31:0] data_in,  
    output reg serial_out,  
    output reg valid  
);  
    reg [5:0] bit_count; // To count bits serialized  
  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            serial_out <= 0;  
            valid <= 0;  
            bit_count <= 0;  
        end else begin  
            if (bit_count < 32) begin  
                serial_out <= data_in[31 - bit_count];  
                valid <= 1;  
                bit_count <= bit_count + 1;  
            end else begin  
                valid <= 0;  
            end  
        end  
    end  
endmodule