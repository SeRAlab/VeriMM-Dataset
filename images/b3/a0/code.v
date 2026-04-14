module top_module(
    input wire clk,                // Added clk input
    input wire [15:0] in,
    output wire [7:0] out_hi,
    output wire [7:0] out_lo
);// Pipeline registers
    reg [15:0] stage1_out;
    reg [7:0] stage2_out_hi, stage2_out_lo;

    // Barrel shifter
    always @(posedge clk) begin            // Moved the assignment for stage1_out into the always block
        stage1_out <= in >> 8;
    end

    // Output registers
    always @(posedge clk) begin
        stage2_out_hi <= stage1_out[15:8];
        stage2_out_lo <= in[7:0];
    end

    // Output assignments
    assign out_hi = stage2_out_hi;
    assign out_lo = stage2_out_lo;

endmodule