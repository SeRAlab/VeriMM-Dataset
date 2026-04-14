module top_module(
    input  wire        clk,
    input  wire [ 7:0] A,
    input  wire [ 7:0] B,
    output wire [15:0] Z
);assign Z = A * B;

    reg [15:0] Z_sync;

    always @(posedge clk)
        Z_sync <= Z;

    assign Z = Z_sync;

endmodule