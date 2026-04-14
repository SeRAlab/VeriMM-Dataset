module adder_32bit(  
    input [31:0] a,  
    input [31:0] b,  
    output reg [31:0] sum,  
    output reg carry_out  
);  
    always @(*) begin  
        {carry_out, sum} = a + b;  
    end  
endmodule