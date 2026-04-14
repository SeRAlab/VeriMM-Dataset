module top_module(
    input [3:0] a, b,
    input [1:0] shift,
    output reg [2:0] comparison_result,
    output reg [3:0] final_output
);reg [3:0] shifted_a;
reg [3:0] shifted_b;

// Barrel Shifter
always @(*) begin
    case (shift)
        2'b00: shifted_a = a;
        2'b01: shifted_a = {a[2:0], 1'b0};
        2'b10: shifted_a = {1'b0, a[3:1]};
        2'b11: shifted_a = {a[1:0], 2'b00};
    endcase
    shifted_b = b;
end

// Magnitude Comparator
always @(*) begin
    if (shifted_a > shifted_b) begin
        comparison_result = 3'b001;
    end else if (shifted_a < shifted_b) begin
        comparison_result = 3'b010;
    end else begin
        comparison_result = 3'b100;
    end
end

// Functional Module
always @(*) begin
    case (comparison_result)
        3'b001: final_output = shifted_a;
        3'b010: final_output = shifted_b;
        3'b100: final_output = shifted_a | shifted_b;
    endcase
end

endmodule