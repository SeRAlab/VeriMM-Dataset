module top_module(
    input clk,
    input reset,
    input ena,
    input parallel_load,
    input serial_in,
    output serial_out,
    output reg [3:0] q,
    input [3:0] data_in
);reg [3:0] gray_q;
    reg [3:0] shift_reg;

    // Gray code counter
    always @(posedge clk) begin
        if (reset) begin
            gray_q <= 4'b0000;
        end else if (ena) begin
            gray_q <= gray_q + 1;
        end else begin
            gray_q <= gray_q - 1;
        end
    end

    // Shift register
    always @(posedge clk) begin
        if (parallel_load) begin
            shift_reg <= data_in;
        end else begin
            shift_reg <= {shift_reg[2:0], serial_in};
        end
    end

    // XOR module
    assign serial_out = shift_reg[0] ^ gray_q[0];
    assign q = gray_q;

endmodule