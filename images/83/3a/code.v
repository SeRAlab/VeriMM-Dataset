module top_module(
    input clk,
    input reset,
    input [31:0] in0,
    input [31:0] in1,
    input [31:0] in2,
    input [31:0] in3,
    input [1:0] sel,
    output reg [31:0] out,
    output reg [31:0] falling_edge_detection
);// 4-to-1 Multiplexer
    always @ (sel or in0 or in1 or in2 or in3) begin
        case(sel)
            2'b00: out <= in0;
            2'b01: out <= in1;
            2'b10: out <= in2;
            2'b11: out <= in3;
            default: out <= 32'b0; // Handling default case
        endcase
    end

    // Falling Edge Detector
    reg [31:0] prev_out;

    always @ (posedge clk or negedge reset) begin
        if (!reset) begin
            prev_out <= 32'b0;
            falling_edge_detection <= 32'b0; // Initialize output on reset
        end else begin
            falling_edge_detection <= (prev_out & ~out);
            prev_out <= out;
        end
    end

    // Comparator for detection of specific value
    always @ (posedge clk or negedge reset) begin
        if (!reset) begin
            falling_edge_detection <= 32'b0; // Initialize output on reset
        end else begin
            if(out == 32'hDEADBEEF) // 32-bit constant value
                falling_edge_detection <= 32'b11111111111111111111111111111111;
            else
                falling_edge_detection <= 32'b00000000000000000000000000000000;
        end
    end

endmodule