module top_module(
    input [3:0] A,
    input [3:0] B,
    input RESET_B,
    input CLK,
    output reg [3:0] SUM
);always @(posedge CLK) begin
        if (RESET_B == 0) begin
            SUM <= 4'b0000;
        end else begin
            SUM <= A + B;
        end
    end

endmodule