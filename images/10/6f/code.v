module data_forwarding_unit(  
    input [7:0] input_a,  
    input [7:0] input_b,  
    input [1:0] forward_ctrl,  
    output reg [7:0] output_data  
);  
    always @(*) begin  
        case (forward_ctrl)  
            2'b00: output_data = input_a;  
            2'b01: output_data = input_b;  
            2'b10: output_data = 8'b00000000; // Default value  
            default: output_data = 8'b00000000;  
        endcase  
    end  
endmodule