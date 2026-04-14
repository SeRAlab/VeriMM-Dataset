module top_module(
    input clk,
    input reset,            // Synchronous reset
    input [31:0] in,
    output [31:0] out,
    output [7:0] q,
    output or_out,
    output [31:0] and_out
);// Module 1: Detect changes in input vector
    reg [31:0] prev_in;
    reg [31:0] out_reg;
    always @(posedge clk) begin
        if (reset) begin
            prev_in <= 0;
            out_reg <= 0;
        end else begin
            prev_in <= in;
            out_reg <= out_reg | (in & ~prev_in);
        end
    end
    assign out = out_reg;

    // Module 2: 8 D flip-flops with active high asynchronous reset
    reg [7:0] dff;
    always @(negedge clk or posedge reset) begin
        if (reset) begin
            dff <= 0;
        end else begin
            dff <= {dff[6:0], in[0]};
        end
    end
    assign q = dff;

    // 9th DFF that outputs the logical OR of all 8 DFF outputs
    reg or_reg;
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            or_reg <= 0;
        end else begin
            or_reg <= |dff;
        end
    end
    assign or_out = or_reg;

    // Additional functional module that outputs the bitwise AND of the two vectors
    assign and_out = out & {8{or_out}};

endmodule