module top_module(clk, iA, iB, iC, oResult);input clk;
    input [3:0] iA;
    input [3:0] iB;
    input iC;
    output reg [3:0] oResult; // Changed to reg type

    always @(posedge clk) begin
        if (iC == 0) begin
            oResult <= iA & iB;
        end else begin
            oResult <= iA | iB;
        end
    end
endmodule