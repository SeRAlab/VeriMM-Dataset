module pattern_detector(
    input clk,
    input reset,
    input data_in,
    output reg pattern_detected
);
    reg [3:0] shift_reg;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            shift_reg <= 4'd0;
            pattern_detected <= 1'b0;
        end else begin
            shift_reg <= {shift_reg[2:0], data_in};
            if (shift_reg == 4'b1010) begin
                pattern_detected <= 1'b1;
            end else begin
                pattern_detected <= 1'b0;
            end
        end
    end
endmodule