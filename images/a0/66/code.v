module Shift_Register_8bit(
   input  [7:0]  D,
   input         clk,
   input         load,
   input         shift,
   output reg [7:0]  Q  
);
    always@(posedge clk) begin
        if(load) begin
            Q <= D;
        end else if(shift) begin
            Q <= {1'b0, Q[7:1]};
        end
    end
endmodule