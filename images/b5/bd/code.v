module Register_16(
   input               clk,
   input               load,
   input               clr,
   input  [15:0]       D,
   output reg [15:0]   Q  
);
    always@(posedge clk) begin
        if(clr) Q <= 16'b0; // Clear the register
        else if(load) Q <= D; // Load the register with input data
    end
endmodule