module register_16bit_with_enable(
    input wire clk,
    input wire rst,
    input wire en,
    input wire [15:0] d,
    output reg [15:0] q
);

    always @(posedge clk) begin
        if (rst) begin
            q <= 16'b0000000000000000;
        end else if (en) begin
            q <= d;
        end
    end
endmodule