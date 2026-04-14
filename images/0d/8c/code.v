module barrel_shifter(  
    input [1:0] data_in,  
    input [1:0] shift_amt,  
    input direction, // 0 for left, 1 for right  
    output reg [1:0] data_out  
);  
    always @(*) begin  
        case ({direction, shift_amt})  
            3'b000: data_out = data_in; // No shift  
            3'b001: data_out = direction ? (data_in >> 1) : (data_in << 1); // Shift by 1  
            3'b010: data_out = direction ? (data_in >> 2) : (data_in << 2); // Shift by 2  
            default: data_out = data_in; // Default case  
        endcase  
    end  
endmodule