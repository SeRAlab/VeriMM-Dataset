module barrel_shifter (  
    input [1:0] in,  
    input [1:0] ctrl,  
    output reg [1:0] out  
);  
    always @(*) begin  
        case (ctrl)  
            2'b00: out = in;       // No shift  
            2'b01: out = {in[0], 1'b0}; // Left shift (logical)  
            2'b10: out = {1'b0, in[1]}; // Right shift (logical)  
            default: out = 2'b00;  
        endcase  
    end  
endmodule