module barrel_shifter(  
    input [7:0] data,  
    input [2:0] shift_amount,  
    input direction,  
    output reg [7:0] shifted_data  
);  
    always @(*) begin  
        if (direction == 0) begin // Left shift  
            shifted_data = data << shift_amount;  
        end else begin // Right shift  
            shifted_data = data >> shift_amount;  
        end  
    end  
endmodule