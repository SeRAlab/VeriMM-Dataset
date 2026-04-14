module Shift_register(
   input                clk,
   input                rst_n,
   input                data_in,

   output reg [7:0]     Q
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) Q <= 8'b00000000;
        else Q <= {Q[6:0], data_in};
    end
endmodule