module even_bits_counter (
    input clk,
    input reset, // Synchronous active-high reset
    input [3:0] in,
    output reg [2:0] out
);

reg [3:0] reg_in;

always @(negedge clk) begin
    if (reset) begin
        reg_in <= 4'b0000;
        out <= 3'b000;
    end
    else begin
        reg_in <= in;
        out <= {reg_in[0]^reg_in[1]^reg_in[2]^reg_in[3], reg_in[1]^reg_in[2]^reg_in[3], reg_in[2]^reg_in[3]};
    end
end

endmodule