module PISO_4(
   input           clk,
   input           rst,
   input [3:0]     PI,
   input           load,
   output          SO  
);
    reg [3:0] Q;
    
    always@(posedge clk) begin
        if(rst) Q <= 4'b0; // Reset the register
        else if(load) Q <= PI; // Load parallel input
        else Q <= {1'b0, Q[3:1]}; // Shift right
    end
    
    assign SO = Q[0]; // Serial output is the last bit of the register
endmodule