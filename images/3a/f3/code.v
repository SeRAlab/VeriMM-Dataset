module serializer_8bit (  
    input clk,  
    input start,  
    input [7:0] parallel_in,  
    output reg serial_out,  
    output reg done  
);  
    reg [2:0] bit_counter;  
    reg [7:0] shift_reg;  

    always @(posedge clk) begin  
        if (start) begin  
            shift_reg <= parallel_in;  
            bit_counter <= 0;  
            done <= 0;  
        end else if (bit_counter < 8) begin  
            serial_out <= shift_reg[bit_counter];  
            bit_counter <= bit_counter + 1;  
        end else begin  
            done <= 1;  
        end  
    end  
endmodule