module serializer_8bit (  
    input wire clk,  
    input wire reset,  
    input wire [7:0] data_in,  
    output reg serial_out,  
    output reg done  
);  
    reg [2:0] bit_count;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            bit_count <= 3'b000;  
            serial_out <= 1'b0;  
            done <= 1'b0;  
        end else if (bit_count < 3'd8) begin  
            serial_out <= data_in[bit_count];  
            bit_count <= bit_count + 1'b1;  
            done <= 1'b0;  
        end else begin  
            done <= 1'b1;  
        end  
    end  
endmodule