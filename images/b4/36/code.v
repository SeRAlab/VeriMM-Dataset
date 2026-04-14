module top_module(
    Y,
    A,
    invert
);// Module ports
    output reg [3:0] Y;
    input [3:0] A;
    input invert;

    // Local signals
    wire [3:0] not_A;
    wire [3:0] one;
    wire [3:0] add_one;
    wire [3:0] twos_comp;

    // Invert A if necessary
    assign not_A = ~A;
    assign not_A = (invert) ? not_A : A;

    // Calculate 1
    assign one = 4'b0001;

    // Calculate add_one
    assign add_one = not_A + one;

    // Calculate twos_comp
    assign twos_comp = (invert) ? ~add_one : add_one;

    // Assign output
    always @(*) begin
        Y <= twos_comp;
    end

endmodule