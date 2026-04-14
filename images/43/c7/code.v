module top_module(
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q,
    output reg [99:0] q_out
);reg [99:0] stage1_out;
    reg [99:0] stage2_out;
    reg [99:0] stage3_out;

    always @(posedge clk) begin
        if (load) begin
            q <= data;
            stage1_out <= data;
            stage2_out <= data;
            stage3_out <= data;
        end else begin
            q <= stage3_out;
            stage1_out <= q;
            stage2_out <= stage1_out;
            stage3_out <= stage2_out;
        end
    end

    always @(*) begin
        case (ena)
            2'b00: q_out = q;
            2'b01: q_out = {q[98:0], q[99]}; // Rotate right
            2'b10: q_out = {q[0], q[99:1]}; // Rotate left (fixed the indexing)
            2'b11: q_out = q;
            default: q_out = q; // Default case for safety
        endcase
    end

endmodule