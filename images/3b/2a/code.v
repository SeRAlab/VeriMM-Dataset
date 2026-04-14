module barrel_shifter(  
    input [1:0] data_in,  
    input dir,  
    output reg [1:0] data_out  
);  
    always @(*) begin  
        case(dir)  
            1'b0: // Left Shift  
                data_out = {data_in[0], data_in[1]}; // No change since 2-bit left shift on 2-bit input is same  
            1'b1: // Right Shift  
                data_out = {data_in[1], data_in[0]}; // Swap for right shift  
            default:  
                data_out = 2'b00; // Default case (should not happen)  
        endcase  
    end  
endmodule