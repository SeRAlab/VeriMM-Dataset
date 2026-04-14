module top_module(
    output reg Y,  // Change output Y to output reg to allow assignment in always block
    input A,
    input B,
    input C,
    input [1:0] op,
    input sel
);wire [2:0] input_signals;
    wire [1:0] selected_signals;
    wire [2:0] and_results;
    wire [2:0] or_results;
    wire [2:0] xor_results;
    wire [2:0] xnor_results;

    // Assign the input signals based on the sel signal
    assign input_signals[0] = (sel == 0) ? A : B;
    assign input_signals[1] = B;
    assign input_signals[2] = (sel == 1) ? C : B;

    // Perform the AND operation on the input signals
    assign and_results[0] = input_signals[0] & input_signals[1];
    assign and_results[1] = input_signals[1] & input_signals[2];
    assign and_results[2] = input_signals[2] & input_signals[0];

    // Perform the OR operation on the input signals
    assign or_results[0] = input_signals[0] | input_signals[1];
    assign or_results[1] = input_signals[1] | input_signals[2];
    assign or_results[2] = input_signals[2] | input_signals[0];

    // Perform the XOR operation on the input signals
    assign xor_results[0] = input_signals[0] ^ input_signals[1];
    assign xor_results[1] = input_signals[1] ^ input_signals[2];
    assign xor_results[2] = input_signals[2] ^ input_signals[0];

    // Perform the XNOR operation on the input signals
    assign xnor_results[0] = ~(input_signals[0] ^ input_signals[1]);
    assign xnor_results[1] = ~(input_signals[1] ^ input_signals[2]);
    assign xnor_results[2] = ~(input_signals[2] ^ input_signals[0]);

    // Determine which two input signals to use based on the sel signal
    assign selected_signals = (sel == 0) ? 2'b00 : 2'b10;

    // Perform the operation based on the op signal
    always @(*) begin
        case (op)
            2'b00: Y = and_results[selected_signals];
            2'b01: Y = or_results[selected_signals];
            2'b10: Y = xor_results[selected_signals];
            2'b11: Y = xnor_results[selected_signals];
            default: Y = 1'b0;
        endcase
    end

endmodule