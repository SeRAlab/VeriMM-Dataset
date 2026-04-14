module top_module(
    output reg Q,
    input CLK,
    input D,
    input SET_B
);// Local signals
    wire SET;

    // Invert SET_B for active set condition
    assign SET = ~SET_B;

    // D Flip-Flop with asynchronous set logic
    always @(posedge CLK or negedge SET) begin
        if (~SET) begin
            Q <= 1'b1;  // Set output to 1 when SET is asserted (SET_B is low)
        end else begin
            Q <= D;     // Capture D value on rising edge of CLK
        end
    end

endmodule