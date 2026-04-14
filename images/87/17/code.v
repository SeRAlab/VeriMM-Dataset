module counter4bit_updown(
    input clk,
    input up_down,
    output reg [3:0] q
);

    always @(posedge clk) begin
        if (up_down)
            q <= q + 1;
        else
            q <= q - 1;
    end

endmodule