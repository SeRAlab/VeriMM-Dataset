module top_module(
    input CLK,
    input RESET_B,
    input [3:0] A,
    output reg [1:0] B
);wire [1:0] B_temp;

    // Comparators
    assign B_temp[1] = (A > 12);
    assign B_temp[0] = (A > 8) & (A <= 12) ? 1'b1 : (A > 4) & (A <= 8) ? 1'b0 : 1'b0;

    // Flip-Flop
    always @(posedge CLK or negedge RESET_B) begin
        if (!RESET_B) begin
            B <= 2'b00; // Reset condition
        end else begin
            B <= B_temp; // Update output B with B_temp
        end
    end

endmodule