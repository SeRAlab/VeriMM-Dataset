module barrel_shifter_2bit (  
    input [3:0] data_in,  
    input shift_dir, // 0 for left shift, 1 for right shift  
    output reg [3:0] data_out  
);  
    always @(*) begin  
        case (shift_dir)  
            0: data_out = {data_in[1:0], 2'b00}; // Left shift  
            1: data_out = {2'b00, data_in[3:2]}; // Right shift  
            default: data_out = 4'b0000;  
        endcase  
    end  
endmodule