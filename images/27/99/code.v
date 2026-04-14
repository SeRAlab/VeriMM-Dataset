module barrel_shifter(input [1:0] in, input ctrl, output reg [1:0] out);  
    always @(*) begin  
        case (ctrl)  
            1'b0: out = in;  
            1'b1: out = {in[0], in[1]}; // Left shift with wrap-around  
            default: out = 2'b00;  
        endcase  
    end  
endmodule