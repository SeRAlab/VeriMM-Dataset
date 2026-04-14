module top_module(
    input [3:0] A,
    input [3:0] B,
    input CLK,
    input RST,
    output [3:0] S
);reg [3:0] sum;

    always @(posedge CLK) begin
        if (RST) begin
            sum <= 0;
        end
        else begin
            sum <= A + B;
        end
    end

    assign S = sum;

endmodule