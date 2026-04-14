module barrel_shifter (  
    input [7:0] data_in,  
    input [2:0] shift_amount,  
    input direction,  // 0 for left shift, 1 for right shift  
    output reg [7:0] data_out  
);  
    always @(*) begin  
        case (direction)  
            1'b0: // Left shift  
                data_out = data_in << shift_amount;  
            1'b1: // Right shift  
                data_out = data_in >> shift_amount;  
            default:  
                data_out = 8'b0;  
        endcase  
    end  
endmodule