module top_module(
    input CLK,
    input D,
    input SCD,
    input SCE,
    input SET_B,
    input VPWR,
    input VGND,
    input VPB,
    input VNB,
    output reg Q,
    output reg Q_N
);reg [1:0] state;
    reg [1:0] next_state; // Change next_state from wire to reg

    // Define the state transitions
    always @(*) begin
        case(state)
            2'b00: begin
                next_state = {SCD, SCE};
            end
            2'b01: begin
                next_state = {SCD, ~SET_B};
            end
            2'b10: begin
                next_state = {~SCE, SET_B};
            end
            2'b11: begin
                next_state = {~SCE, ~SET_B};
            end
            default: next_state = 2'b00; // Add default case
        endcase
    end

    // Define the state machine
    always @(posedge CLK) begin
        state <= next_state;
    end

    // Define the output functions based on the current state
    always @(*) begin
        // Output logic based on current state
        Q = (state == 2'b10 || state == 2'b11) ? 1'b1 : 1'b0;
        Q_N = ~Q;
    end

endmodule