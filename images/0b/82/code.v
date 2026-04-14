module barrel_shifter (  
    input [7:0] data_in,  
    input [2:0] shift_amt,  
    input direction, // 0 for left, 1 for right  
    output reg [7:0] data_out  
);  
    always @(*) begin  
        case (direction)  
            1'b0: // Left shift  
                data_out = data_in << shift_amt;  
            1'b1: // Right shift  
                data_out = data_in >> shift_amt;  
            default:  
                data_out = data_in;  
        endcase  
    end  
endmodule