module top_module(
    input [7:0] a,
    input [7:0] b,
    input select_ctrl,
    input add_sub_ctrl,
    output [7:0] Q  // Changed output to match width of signals
);wire [7:0] add_sub_out;
    wire mux_enable;

    // 8-bit adder/subtractor with overflow detection
    // Defining a simple adder/subtractor module inline
    wire overflow;
    assign add_sub_out = add_sub_ctrl ? (a - b) : (a + b); // Simple adder/subtractor
    assign overflow = (add_sub_ctrl && (a < b)) || (!add_sub_ctrl && (add_sub_out < a)); // Overflow logic

    // 4-to-1 multiplexer with enable
    // Defining a simple multiplexer module inline
    reg [7:0] mux_out;
    always @(*) begin
        case (select_ctrl)
            2'b00: mux_out = add_sub_out;
            2'b01: mux_out = 8'h00;
            2'b10: mux_out = 8'h00;
            2'b11: mux_out = 8'h00;
            default: mux_out = 8'h00;
        endcase
    end

    assign Q = mux_enable ? mux_out : 8'h00;  // Only allow mux_out on enable

    // Enable control signal for the multiplexer
    assign mux_enable = add_sub_ctrl;

endmodule