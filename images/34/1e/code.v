module barrel_shifter(  
    input [1:0] data_in,  
    input dir,  // 0 for left shift, 1 for right shift  
    output reg [1:0] data_out  
);  
always @(*) begin  
    case(dir)  
        1'b0: data_out = {data_in[0], 1'b0}; // Left shift  
        1'b1: data_out = {1'b0, data_in[1]}; // Right shift  
        default: data_out = 2'b00;  
    endcase  
end  
endmodule