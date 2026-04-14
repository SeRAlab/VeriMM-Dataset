module top_module(
    input [15:0] minuend,
    input [15:0] subtrahend,
    input control,
    output reg [15:0] result  // Change wire to reg to use in always block
);wire [15:0] twos_complement_subtrahend;
    assign twos_complement_subtrahend = (~subtrahend) + 1;

    always @(*) begin
        if (control) begin
            result = minuend + twos_complement_subtrahend;
        end else begin
            result = minuend + subtrahend;
        end
    end

endmodule