module register_4bit(
    input clk,
    input ld,
    input [3:0] data,
    output reg [3:0] q
);

    always @(posedge clk) begin
        if (ld)
            q <= data;
    end

endmodule