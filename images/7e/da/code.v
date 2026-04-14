module register_16bit(
    input wire clk,
    input wire rst,
    input wire en,
    input wire [15:0] data,
    output reg [15:0] q
);

    always @(posedge clk) begin
        if (rst) begin
            q <= 16'b0000000000000000;
        end else if (en) begin
            q <= data;
        end
    end
endmodule