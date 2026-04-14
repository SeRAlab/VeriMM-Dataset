module counter2bit(
    input clk,
    output reg [1:0] q
);

    always @(posedge clk) begin
        q <= q + 1;
    end

endmodule