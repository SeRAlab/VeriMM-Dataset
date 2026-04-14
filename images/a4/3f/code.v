module top_module(
    input clk,
    input reset,
    input [3:0] in,
    output reg [6:0] seg_out
);reg [3:0] shift_reg;
    reg [3:0] seq = 4'b1100;
    reg [3:0] seq_detect;
    reg detect;

    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 4'b0000;
            detect <= 0;
            seq_detect <= 4'b0000;
            seg_out <= 7'b0000000;
        end
        else begin
            shift_reg <= {in, shift_reg[3:1]};
            seq_detect <= {shift_reg[2:0], in};
            if (seq_detect == seq) begin
                detect <= 1;
            end
            if (detect) begin
                seg_out <= 7'b0110000; // Display "1"
            end
            else begin
                seg_out <= 7'b0000000; // Display "0"
            end
        end
    end

endmodule