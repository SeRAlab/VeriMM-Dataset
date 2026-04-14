module barrel_shifter(  
    input [3:0] data_in,  
    input shift_dir,  // 1 for left shift, 0 for right shift  
    output reg [3:0] data_out  
);  
    always @(*) begin  
        case(shift_dir)  
            1'b1: data_out = {data_in[1:0], 2'b00};  // Left shift  
            1'b0: data_out = {2'b00, data_in[3:2]};  // Right shift  
            default: data_out = 4'b0000;  
        endcase  
    end  
endmodule