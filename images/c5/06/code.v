module RegisterAdd #(parameter WIDTH=26) (
    input CLK,
    input RESET,
    input [WIDTH-1:0] A,
    input [WIDTH-1:0] B,
    output reg [WIDTH-1:0] SUM
    );

    always @(posedge CLK) begin
        if (RESET == 0) begin
            SUM <= 0;
        end else begin
            SUM <= A + B;
        end
    end

endmodule