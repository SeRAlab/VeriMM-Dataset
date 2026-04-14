module barrel_shifter(  
    input [7:0] data_in,  
    input [2:0] shift_amount,  
    input direction,  // 0 for left, 1 for right  
    output reg [7:0] data_out  
);  
    always @(*) begin  
        if (direction == 0) begin  // Shift left  
            data_out = data_in << shift_amount;  
        end else begin  // Shift right  
            data_out = data_in >> shift_amount;  
        end  
    end  
endmodule