module barrel_shifter(  
    input [1:0] data_in,  
    input direction,  
    output reg [1:0] data_out  
);  
    always @(*) begin  
        case (direction)  
            1'b0: data_out = {data_in[0], data_in[1]}; // Shift left  
            1'b1: data_out = {data_in[1], 1'b0}; // Shift right  
            default: data_out = 2'bxx;  
        endcase  
    end  
endmodule