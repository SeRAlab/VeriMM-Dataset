module serializer_8bit (  
    input clk,  
    input rst,  
    input start,  
    input [7:0] parallel_in,  
    output reg serial_out  
);  

    reg [2:0] bit_count;  
    reg [7:0] shift_reg;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            bit_count <= 3'b000;  
            shift_reg <= 8'b0;  
            serial_out <= 1'b0;  
        end else if (start) begin  
            if (bit_count < 3'b111) begin  
                serial_out <= shift_reg[7];  
                shift_reg <= {shift_reg[6:0], 1'b0};  
                bit_count <= bit_count + 1;  
            end else begin  
                serial_out <= 1'b0; // Output idle state after 8 bits  
            end  
        end else begin  
            shift_reg <= parallel_in;  
            bit_count <= 3'b0;  
        end  
    end  
endmodule