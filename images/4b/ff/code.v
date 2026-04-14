module register_4bit(
    input wire [3:0] d,
    input wire clk,
    input wire en_n,
    output reg [3:0] q
);

    always @(posedge clk) begin
        if (!en_n)
            q <= d;
    end

endmodule