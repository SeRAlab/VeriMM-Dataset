module top_module(
    input [7:0] A,
    input [7:0] B,
    input EN,
    input CLR,
    output [7:0] S,
    output COUT
);reg [8:0] sum;

    always @(*) begin
        if (CLR) begin
            sum <= 0;
        end
        else if (EN) begin
            sum <= {1'b0, A} + {1'b0, B} + sum[8];
        end
    end

    assign S = sum[7:0];
    assign COUT = sum[8];

endmodule