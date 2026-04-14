module Shift_register_16(
   input                clk,
   input                rst_n,
   input                load,
   input  [15:0]        parallel_in,
   output reg           serial_out
);
    reg [15:0] shift_reg;
    
    always@(posedge clk or negedge rst_n) begin
        if(!rst_n) shift_reg <= 16'd0;
        else if(load) shift_reg <= parallel_in;
        else shift_reg <= {1'b0, shift_reg[15:1]};
    end
    
    always@(posedge clk or negedge rst_n) begin
        if(!rst_n) serial_out <= 1'b0;
        else serial_out <= shift_reg[0];
    end
endmodule