module top_module(clk, rn1, do1, rn2, do2, we2, di2);input clk;
    input [4:0] rn1;
    output reg [31:0] do1;
    input [4:0] rn2;
    output reg [31:0] do2;
    input we2;
    input [31:0] di2;

    reg [31:0] r[0:31];

    always @(posedge clk) begin
        do1 <= r[rn1];
        if (we2 == 0) begin
            do2 <= r[rn2];
        end else begin
            do2 <= di2;
            r[rn2] <= di2;
        end
    end

endmodule