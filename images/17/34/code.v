module serializer_8b (  
    input wire clk,  
    input wire reset,  
    input wire start,  
    input wire [7:0] parallel_in,  
    output reg serial_out,  
    output reg done  
);  
    reg [2:0] count;  
    reg [7:0] shift_reg;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            count <= 3'b000;  
            shift_reg <= 8'b00000000;  
            serial_out <= 1'b0;  
            done <= 1'b0;  
        end else if (start) begin  
            if (count < 3'b100) begin  
                shift_reg <= parallel_in;  
                serial_out <= shift_reg[7];  
                shift_reg <= {shift_reg[6:0], 1'b0};  
                count <= count + 1;  
            end else begin  
                done <= 1'b1;  
            end  
        end  
    end  
endmodule