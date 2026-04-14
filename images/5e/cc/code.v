module fibonacci_lfsr_6(
   input                clk ,
   input                rst_n,
 
   output reg [5:0]     Q  
);
    wire feedback;

    assign feedback = Q[5] ^ Q[4];
    
    always@(posedge clk or negedge rst_n)begin
        if(!rst_n) Q <= 6'b111111;
        else Q <= {Q[4:0], feedback};
    end
endmodule