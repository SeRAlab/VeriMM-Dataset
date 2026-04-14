module top_module(
    input  wire        clk,
    input  wire        clr,
    input  wire [ 7:0] A,
    input  wire [ 7:0] B,
    output reg  [15:0] Z
);reg [15:0] acc;

    always @(posedge clk) begin
        if (clr) begin
            acc <= 0;
        end else begin
            acc <= A * B;
        end
    end

    assign Z = acc;

endmodule