module mux4to1 (  
    input [7:0] data0,  
    input [7:0] data1,  
    input [7:0] data2,  
    input [7:0] data3,  
    input [1:0] select,  
    output reg [7:0] out  
);  
    always @(*) begin  
        case (select)  
            2'b00: out = data0;  
            2'b01: out = data1;  
            2'b10: out = data2;  
            2'b11: out = data3;  
            default: out = 8'b00000000;  
        endcase  
    end  
endmodule