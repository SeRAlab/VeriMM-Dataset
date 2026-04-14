module register_4bit (
    input wire [3:0] d,
    input wire clk,
    input wire enable,
    output reg [3:0] q
);

    always @(posedge clk) begin
        if (enable)
            q <= d;
    end

endmodule