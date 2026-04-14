module lfsr_32bit(
   input                clk ,
   input                rst_n,
   input  [31:0]        seed,
 
   output reg [31:0]    Q  
);
    wire feedback;

    assign feedback = Q[31] ^ Q[21] ^ Q[1] ^ Q[0];

    always@(posedge clk or negedge rst_n)begin
        if(!rst_n) Q <= seed;
        else Q <= {Q[30:0], feedback};
    end
endmodule