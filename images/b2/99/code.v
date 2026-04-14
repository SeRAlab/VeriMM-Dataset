module bin_to_bcd(
    input clk,
    input reset,
    input [3:0] bin,
    output reg [3:0] bcd
);

    always @(posedge clk) begin
        if (reset) begin
            // Synchronous reset
            bcd <= 4'b0000;
        end else begin
            // Binary to BCD conversion logic
            bcd <= (bin >= 4'b1010) ? (bin + 4'b0110) : bin;
        end
    end

endmodule