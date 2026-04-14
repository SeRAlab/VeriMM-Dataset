module top_module(
    input  wire        clk,
    input  wire        rst,
    input  wire        clr,
    input  wire        ena,
    input  wire [ 7:0] A,
    input  wire [ 7:0] B,
    output reg  [15:0] Z
);always @(posedge clk or posedge rst)
        if (rst)     Z <= 0;
        else if (ena) begin
            if (clr) Z <=     (A * B);
            else     Z <= Z + (A * B);
        end

endmodule