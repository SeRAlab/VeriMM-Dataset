module serializer (  
    input clk,  
    input rst,  
    input start,  
    input [7:0] data_in,  
    output reg serial_out,  
    output reg done  
);  
    reg [2:0] bit_count;  
    reg [7:0] shift_reg;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            bit_count <= 0;  
            serial_out <= 0;  
            done <= 0;  
        end  
        else if (start && bit_count == 0) begin  
            shift_reg <= data_in;  
            bit_count <= 7;  
            done <= 0;  
        end  
        else if (bit_count > 0) begin  
            serial_out <= shift_reg[bit_count];  
            bit_count <= bit_count - 1;  
        end  
        else if (bit_count == 0 && !done) begin  
            done <= 1;  
        end  
    end  
endmodule