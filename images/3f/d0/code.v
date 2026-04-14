module deserializer_16bit (  
    input clk,  
    input rst,  
    input serial_in,  
    output reg [15:0] parallel_out  
);  

    reg [3:0] bit_count;  
    reg [15:0] shift_reg;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            bit_count <= 0;  
            parallel_out <= 0;  
            shift_reg <= 0;  
        end else begin  
            if (bit_count < 16) begin  
                shift_reg <= {shift_reg[14:0], serial_in};  
                bit_count <= bit_count + 1;  
            end  
            if (bit_count == 15) begin  
                parallel_out <= shift_reg;  
                bit_count <= bit_count + 1; // move to the next state  
            end  
        end  
    end  
endmodule