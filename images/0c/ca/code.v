module barrel_shifter(  
    input [7:0] data_in,  
    input [2:0] shift_amount,  
    input dir,  // dir = 0 for left shift, dir = 1 for right shift  
    output reg [7:0] data_out  
);  
    always @(*) begin  
        if (dir == 0) begin  // Left shift  
            data_out = data_in << shift_amount;  
        end else begin  // Right shift  
            data_out = data_in >> shift_amount;  
        end  
    end  
endmodule