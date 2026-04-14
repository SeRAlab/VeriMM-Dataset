module top_module(
    input [3:0] A,
    input [1:0] shift_amount,
    input shift_dir,
    output [3:0] Y
);reg [3:0] shifted;

    always @(*) begin
        if (shift_dir) // left shift
            shifted = A << shift_amount; // perform left shift
        else // right shift
            shifted = A >> shift_amount; // perform right shift
    end

    assign Y = shifted;

endmodule