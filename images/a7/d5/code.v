module Shift_reg_16(
   input                clk,
   input                rst_n,
   input                serial_in,
   output reg [15:0]    parallel_out  
);
    always@(posedge clk or negedge rst_n)begin
        if(!rst_n) parallel_out <= 16'd0;
        else parallel_out <= {parallel_out[14:0], serial_in};
    end
endmodule