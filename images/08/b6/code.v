module serializer_32bit (  
    input wire clk,  
    input wire reset,  
    input wire [31:0] data_in,  
    output reg serial_out  
);  

    reg [31:0] shift_reg;  
    integer count;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            shift_reg <= 32'b0;  
            count <= 0;  
            serial_out <= 0;  
        end else begin  
            if (count < 32) begin  
                shift_reg <= data_in;  
                serial_out <= shift_reg[31];  
                shift_reg <= {shift_reg[30:0], 1'b0};  
                count <= count + 1;  
            end  
        end  
    end  
endmodule