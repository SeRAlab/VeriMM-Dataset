module top_module(
    input clk,
    input [7:0] d1,
    input [7:0] d2,
    input select,
    output reg [7:0] q,
    output reg error_flag
);reg [7:0] shift_reg;
    reg [7:0] dff_out;
    reg parity_bit;

    // Parity Checker
    always @(*) begin
        // Calculate the parity bit for d1 and d2
        parity_bit = d1[0] ^ d1[1] ^ d1[2] ^ d1[3] ^ d1[4] ^ d1[5] ^ d1[6] ^ d1[7];
        parity_bit = parity_bit ^ (d2[0] ^ d2[1] ^ d2[2] ^ d2[3] ^ d2[4] ^ d2[5] ^ d2[6] ^ d2[7]);
        parity_bit = ~parity_bit;  // Invert the bit to get the final parity value
    end

    // Control Logic
    always @(posedge clk) begin
        if (select == 1'b0) begin
            // D Flip-Flop
            dff_out <= d1;
            shift_reg <= shift_reg;
        end else begin
            // Shift Register
            dff_out <= dff_out;
            shift_reg <= {shift_reg[6:0], d2};
        end
    end

    // Output Logic
    always @(posedge clk) begin
        if (select == 1'b0) begin
            q <= dff_out;
        end else begin
            q <= shift_reg;
        end
        error_flag <= parity_bit; // Assign the calculated parity to error_flag
    end

endmodule