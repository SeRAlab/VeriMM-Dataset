module top_module(
    input [3:0] in0,
    input [3:0] in1,
    input sub,
    input clk,         // Added clk input
    output reg [3:0] out,  // Changed output to reg
    output reg OVF    // Changed output to reg
);reg [3:0] sum, diff;
reg [3:0] reg_in0, reg_in1;
reg [1:0] stage;

always @(*) begin
    reg_in0 = in0;
    reg_in1 = in1;
    // stage should not be set here, it will be managed in the always block with clk
end

always @(posedge clk) begin
    case(stage)
        0: begin
            sum <= reg_in0 + reg_in1;
            diff <= reg_in0 - reg_in1;
            stage <= 1;
        end
        1: begin
            OVF <= (sum[3] ^ reg_in0[3] ^ reg_in1[3]) ? 1'b1 : 1'b0; // Fixed overflow detection
            out <= (sub) ? diff : sum; // Moved out assignment here to keep it in sync with clock
            stage <= 0;
        end
    endcase
end

endmodule