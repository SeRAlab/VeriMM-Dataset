module top_module(
    CLK,
    D,
    LD,
    RST,
    Q
);// Module ports
    input  CLK;
    input  [3:0] D;
    input  LD;
    input  RST;
    output reg [3:0] Q; // Change to reg type

    // Local signals
    wire [3:0] reg_Q;
    wire de_d;

    // Asynchronous reset and load
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            Q <= 4'b0000; // Reset output
        end else if (LD) begin
            Q <= D; // Load data
        end
    end

    // Connect the intermediate flip-flop output
    assign reg_Q = Q;

endmodule