module top_module (
    input wire [1:0] d,
    input wire clk,
    input wire en,
    output reg [1:0] q
);

    always @(posedge clk) begin
        if (en)
            q <= d;
    end

endmodule