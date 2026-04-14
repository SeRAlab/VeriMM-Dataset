module barrel_shifter_2bit(  
    input [1:0] data_in,  
    input control,  
    output reg [1:0] data_out  
);  
    always @(*) begin  
        case(control)  
            1'b0: data_out = {data_in[0], 1'b0}; // Shift left  
            1'b1: data_out = {1'b0, data_in[1]}; // Shift right  
            default: data_out = 2'b00;  
        endcase  
    end  
endmodule