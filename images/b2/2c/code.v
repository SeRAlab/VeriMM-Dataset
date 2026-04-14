module SimpleRegister (
    input clk,
    input en,
    input [7:0] d,
    output reg [7:0] q
);

    always @(posedge clk) begin
        if (en) begin
            q <= d;
        end
    end
endmodule