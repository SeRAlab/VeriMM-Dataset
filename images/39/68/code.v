module serializer_8bit (  
    input wire clk,  
    input wire reset,  
    input wire start,  
    input wire [7:0] parallel_in,  
    output reg serial_out,  
    output reg done  
);  
    reg [3:0] bit_count;  
    reg [7:0] shift_reg;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            serial_out <= 1'b0;  
            done <= 1'b0;  
            bit_count <= 4'd0;  
            shift_reg <= 8'd0;  
        end else begin  
            if (start && bit_count == 4'd0) begin  
                shift_reg <= parallel_in;  
                bit_count <= 4'd8;  
                done <= 1'b0;  
            end else if (bit_count > 0) begin  
                serial_out <= shift_reg[7];  
                shift_reg <= {shift_reg[6:0], 1'b0};  
                bit_count <= bit_count - 1;  
            end else if (bit_count == 4'd0 && !done) begin  
                done <= 1'b1;  
            end  
        end  
    end  
endmodule