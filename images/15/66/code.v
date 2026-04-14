module barrel_shifter(  
    input [7:0] data_in,  
    input [1:0] control,  
    output reg [7:0] data_out  
);  

    always @(*) begin  
        case (control)  
            2'b00: data_out = data_in; // No shift  
            2'b01: data_out = {data_in[6:0], 1'b0}; // Shift left by 1  
            2'b10: data_out = {data_in[5:0], 2'b00}; // Shift left by 2  
            2'b11: data_out = {data_in[4:0], 3'b000}; // Shift left by 3  
            default: data_out = 8'b00000000;  
        endcase  
    end  
endmodule