module register8bit(
    input clk,
    input clr,
    input [7:0] d,
    
    output reg [7:0] q
);

always @(posedge clk or posedge clr) begin
    if (clr)
        q <= 8'b00000000;
    else
        q <= d;
end

endmodule