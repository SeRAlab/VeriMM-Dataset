module top_module(
    input [3:0] A,
    input [3:0] B,
    input mode,
    input reset,
    input carry_in,
    input CLK,
    output reg [3:0] C,    // Change output C to reg type
    output wire carry_out
);wire [3:0] sum;
    wire [4:0] full_sum;

    assign full_sum = {carry_in, A} + {mode, B};

    assign sum = full_sum[3:0];

    assign carry_out = full_sum[4];

    always @(posedge CLK) begin
        if (reset) begin
            C <= 4'b0;
        end else begin
            C <= sum;
        end
    end

endmodule