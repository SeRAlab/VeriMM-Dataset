module top_module(
    input  wire RESET_B,
    input  wire CLK_N,
    input  wire D,
    output reg  Q,
    input  wire VPWR,
    input  wire VGND
);// Define internal wires
    wire        CLK_P;
    wire        RESET_B_N;

    // Invert reset signal
    assign      RESET_B_N = ~RESET_B;

    // Generate positive edge clock signal
    assign      CLK_P = ~CLK_N;

    // D flip-flop with asynchronous reset
    always @(posedge CLK_P or negedge RESET_B_N) begin
        if (!RESET_B_N) begin
            Q <= 0;
        end else begin
            Q <= D;
        end
    end

endmodule