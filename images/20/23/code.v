module mux_2to1 (  
    input [7:0] data0,  
    input [7:0] data1,  
    input sel,  
    output reg [7:0] out  
);  

    always @(*) begin  
        case(sel)  
            1'b0: out = data0;  
            1'b1: out = data1;  
            default: out = 8'b00000000;  
        endcase  
    end  
endmodule