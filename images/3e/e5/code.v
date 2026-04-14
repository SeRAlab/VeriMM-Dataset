module serializer_8bit (  
    input wire clk,  
    input wire reset,  
    input wire enable,  
    input wire [7:0] parallel_in,  
    output reg serial_out  
);  
    reg [2:0] bit_count;  
    reg [7:0] shift_reg;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            bit_count <= 3'b000;  
            shift_reg <= 8'b0;  
            serial_out <= 1'b0;  
        end else if (enable) begin  
            if (bit_count < 8) begin  
                shift_reg <= parallel_in;  
                serial_out <= shift_reg[7];  
                shift_reg <= {shift_reg[6:0], 1'b0};  
                bit_count <= bit_count + 1;  
            end else begin  
                serial_out <= 1'b0; // No more bits to send  
            end  
        end  
    end  
endmodule