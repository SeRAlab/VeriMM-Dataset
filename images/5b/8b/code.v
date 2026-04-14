module SISO_8(
   input           clk,
   input           rst,
   input           SI,
   output          SO  
);
    reg [7:0] Q;
    
    always@(posedge clk or posedge rst) begin
        if(rst) Q <= 8'b0; // Reset the register
        else Q <= {SI, Q[7:1]}; // Shift right and add SI
    end
    
    assign SO = Q[0]; // Serial output is the last bit of the register
endmodule