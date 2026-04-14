module top_module(
    input clk,
    input in_valid,
    input out_ready,
    input [N-1:0] in,
    input [N-1:0] sRA,
    input [N-1:0] sWA,
    input [N-1:0] sW,
    output [N-1:0] sR,
    output [1:0] sB
);localparam N = 1024;
    reg [N-1:0] mem [0:N-1]; // Declare memory as a 2D reg array
    reg [N-1:0] sRA_next;
    reg [N-1:0] sWA_next;

    assign sB = (sRA >= N) ? 2'b11 : 2'b00;

    always @(posedge clk) begin
        if (in_valid && sWA_next < N) begin
            mem[sWA_next] <= sW;
            sWA_next <= sWA_next + 1;
        end
    end

    assign sR = (sRA < N) ? mem[sRA] : 0;

endmodule