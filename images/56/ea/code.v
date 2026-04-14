module top_module(
    input clk,
    input reset,      // synchronous active-high reset
    input in,         // input signal to be delayed
    input [3:0] delay, // number of clock cycles to delay the input signal
    output [3:0] q    // 4-bit output from the functional module
);reg [3:0] shift_reg;    // 4-bit shift register
    reg [3:0] counter;      // 4-bit state machine counter
    wire [3:0] delayed_out; // delayed output from the shift register

    assign q = delayed_out & counter; // bitwise AND operation between the delayed output and the counter output

    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 4'b0;
            counter <= 4'b0;
        end
        else begin
            // Shift register operation
            shift_reg[0] <= in;
            shift_reg[1] <= shift_reg[0];
            shift_reg[2] <= shift_reg[1];
            shift_reg[3] <= shift_reg[2];

            // State machine operation
            if (counter == delay) begin
                counter <= 4'b0;
            end
            else begin
                counter <= counter + 1;
            end
        end
    end

    assign delayed_out = shift_reg;

endmodule