module top_module(
    input clk, reset, 
    input [2:0] SW, 
    output reg [3:0] LED
);reg [2:0] SW_reg;
always @(posedge clk, posedge reset) begin
    if (reset) begin
        SW_reg <= 3'b0;
        LED <= 4'b0;
    end else begin
        SW_reg <= SW;
        LED <= SW_reg + 1;
    end
end

endmodule