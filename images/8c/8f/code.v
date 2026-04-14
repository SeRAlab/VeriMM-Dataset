module DFF_4bit(
   input       [3:0]    D,
   input                clk,
   input                rst,
 
   output reg  [3:0]    Q  
);
    always @(posedge clk or posedge rst) begin
        if(rst)
            Q <= 4'b0000;
        else
            Q <= D;
    end
endmodule