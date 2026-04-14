module barrel_shifter(  
    input [3:0] in,  
    input [1:0] shift_amt,  
    input dir, // 0 for left shift, 1 for right shift  
    output reg [3:0] out  
);  
    always @(*) begin  
        case ({dir, shift_amt})  
            3'b00_00: out = in;          // No Shift  
            3'b00_01: out = {in[2:0], 1'b0}; // Left Shift by 1  
            3'b00_10: out = {in[1:0], 2'b00}; // Left Shift by 2  
            3'b00_11: out = {in[0], 3'b000}; // Left Shift by 3  
            3'b01_00: out = in;          // No Shift  
            3'b01_01: out = {1'b0, in[3:1]}; // Right Shift by 1  
            3'b01_10: out = {2'b00, in[3:2]}; // Right Shift by 2  
            3'b01_11: out = {3'b000, in[3]}; // Right Shift by 3  
            default: out = 4'b0000;  
        endcase  
    end  
endmodule