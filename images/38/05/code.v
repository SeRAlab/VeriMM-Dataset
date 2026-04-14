module decoder3to8(  
    input wire [2:0] in,  
    input wire en,  
    output reg [7:0] out  
);  
    always @(*) begin  
        if (en)  
            out = 1 << in;  
        else  
            out = 8'b00000000;  
    end  
endmodule