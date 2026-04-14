module top_module(
    input [3:0] A, B, C, D,
    input VDD, GND,
    output reg Y
);// Local signals
    wire [3:0] nor_out;
    wire all_zero;

    // 4-input NOR gate
    assign nor_out = ~(A | B | C | D);

    // Check if all inputs are 0
    assign all_zero = (A == 0) & (B == 0) & (C == 0) & (D == 0);

    // Buffer output
    always @ (posedge VDD, negedge GND) begin
        if (GND == 0) begin
            Y <= 0;
        end
        else if (all_zero) begin
            Y <= 1;
        end
        else begin
            Y <= nor_out[0];
        end
    end

endmodule