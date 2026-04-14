module deserializer (  
    input wire clk,  
    input wire reset,  
    input wire serial_in,  
    output reg [7:0] parallel_out,  
    output reg data_valid  
);  
    reg [2:0] bit_count;  
    reg [7:0] shift_reg;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            bit_count <= 0;  
            shift_reg <= 0;  
            parallel_out <= 0;  
            data_valid <= 0;  
        end else begin  
            shift_reg <= {shift_reg[6:0], serial_in};  
            bit_count <= bit_count + 1;  

            if (bit_count == 7) begin  
                parallel_out <= shift_reg;  
                data_valid <= 1;  
                bit_count <= 0;  
            end else begin  
                data_valid <= 0;  
            end  
        end  
    end  
endmodule