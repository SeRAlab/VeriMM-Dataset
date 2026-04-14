module LFSR_8(
   input                clk,
   input                rst_n,
   output reg [7:0]     Q  
);
    wire feedback;
    
    assign feedback = Q[7] ^ Q[5] ^ Q[4] ^ Q[3];
    
    always@(posedge clk or negedge rst_n) begin
        if(!rst_n) Q <= 8'b00000001; // Initial seed value
        else Q <= {feedback, Q[7:1]};
    end
endmodule