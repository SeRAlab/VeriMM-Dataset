module top_module(
    input clk, rst_n,
    input [10:0] period,
    output reg clk_out
    );reg[10:0] counter;

always@(posedge clk,negedge rst_n) begin
    if(~rst_n) begin
        counter <= 0;
        clk_out <= 0;
    end
    else if(counter >= ((period >> 1) - 1)) begin
        clk_out <= ~clk_out;
        counter <= 0;
    end
    else begin
        counter <= counter + 1;
    end
end 
endmodule