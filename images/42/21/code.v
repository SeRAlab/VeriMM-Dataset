module JohnsonCounter_3(
   input           clk,
   input           rst,
   output reg [2:0] Q  
);
    always@(posedge clk) begin
        if(rst) Q <= 3'b0; // Reset the counter
        else Q <= {~Q[0], Q[2:1]}; // Shift right and invert the LSB
    end
endmodule