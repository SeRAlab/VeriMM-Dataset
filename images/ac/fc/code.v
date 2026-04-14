module lfsr #(
    parameter WIDTH = 16,
    parameter POLY = 16'hB400
) (
    input wire clk,
    input wire rst,
    input wire load,
    input wire [WIDTH-1:0] seed,
    output reg [WIDTH-1:0] lfsr_out
);

always @(posedge clk) begin
    if (rst) begin
        lfsr_out <= seed;
    end else if (load) begin
        lfsr_out <= seed;
    end else begin
        lfsr_out <= {lfsr_out[WIDTH-2:0], lfsr_out[WIDTH-1] ^ (lfsr_out & POLY)};
    end
end

endmodule