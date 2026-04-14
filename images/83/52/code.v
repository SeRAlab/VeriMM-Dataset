module serial_to_parallel_8bit
(
    input clk,
    input rst_n,
    input serial_in,
    output reg [7:0] result,
    output reg o_ready
);

reg [2:0] bit_count;
reg [7:0] shift_reg;

always @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
        bit_count <= 3'd0;
        shift_reg <= 8'd0;
        result <= 8'd0;
        o_ready <= 1'b0;
    end else begin
        shift_reg <= {shift_reg[6:0], serial_in};
        bit_count <= bit_count + 1;
        if (bit_count == 3'd7) begin
            result <= shift_reg;
            o_ready <= 1'b1;
        end else begin
            o_ready <= 1'b0;
        end
    end
end

endmodule