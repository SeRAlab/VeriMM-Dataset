module barrel_shifter(  
    input [3:0] data_in,  
    input [1:0] shift_amount,  
    input direction, // 0 for left shift, 1 for right shift  
    output [3:0] data_out  
);  
    assign data_out = (direction == 0) ? (data_in << shift_amount) : (data_in >> shift_amount);  
endmodule