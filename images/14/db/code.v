module mux_8bit (  
    input [7:0] in0,  
    input [7:0] in1,  
    input sel,  
    output reg [7:0] out  
);  

    always @(*) begin  
        case (sel)  
            1'b0: out = in0;  
            1'b1: out = in1;  
            default: out = 8'b00000000;  
        endcase  
    end  
endmodule