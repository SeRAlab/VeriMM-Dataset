module phase_shifter(  
    input [2:0] data_in,  
    input [1:0] control,  
    output reg [2:0] data_out  
);  
    always @(*) begin  
        case(control)  
            2'b00: data_out = data_in; // No rotation  
            2'b01: data_out = {data_in[1:0], data_in[2]}; // Rotate left by 1  
            2'b10: data_out = {data_in[0], data_in[2:1]}; // Rotate left by 2  
            2'b11: data_out = {data_in[1:0], data_in[2]}; // Rotate left by 3 (same as no rotation)  
            default: data_out = 3'b000;  
        endcase  
    end  
endmodule