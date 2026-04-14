module serializer_16bit (  
    input wire clk,  
    input wire reset,  
    input wire [15:0] data_in,  
    output reg serial_out  
);  
    reg [15:0] shift_reg;  
    integer count;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            shift_reg <= 16'b0;  
            serial_out <= 1'b0;  
            count <= 0;  
        end else begin  
            if (count < 16) begin  
                shift_reg <= data_in;  
                serial_out <= shift_reg[15];  
                shift_reg <= {shift_reg[14:0], 1'b0};  
                count <= count + 1;  
            end  
        end  
    end  
endmodule