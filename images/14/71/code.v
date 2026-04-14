module barrel_shifter (  
    input [1:0] data_in,  
    input dir,  
    output reg [1:0] data_out  
);  
    always @(*) begin  
        case (dir)  
            1'b0: data_out = {data_in[0], data_in[1]}; // Left shift  
            1'b1: data_out = {data_in[1], 1'b0}; // Right shift  
            default: data_out = 2'b00;  
        endcase  
    end  
endmodule