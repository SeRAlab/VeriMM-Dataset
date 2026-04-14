module top_module(
    input [15:0] in,
    input [3:0] shift_amt,
    input shift_left,
    output reg [15:0] out
);always @(*) begin
        if (shift_left) begin
            // Perform left shift
            out = in << shift_amt;  // Shift left by shift_amt bits
        end else begin
            // Perform right shift
            out = in >> shift_amt;  // Shift right by shift_amt bits
        end
    end

endmodule