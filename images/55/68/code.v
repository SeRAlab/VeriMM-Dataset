module PIPO_16(
   input           clk,
   input           rst,
   input [15:0]    PI,
   input           load,
   output [15:0]   PO  
);
    reg [15:0] Q;
    
    always@(posedge clk) begin
        if(rst) Q <= 16'b0; // Reset the register
        else if(load) Q <= PI; // Load parallel input
    end
    
    assign PO = Q; // Parallel output is the current value of the register
endmodule