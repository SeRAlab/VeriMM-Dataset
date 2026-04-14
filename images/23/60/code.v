module branch_predictor (
    input wire clk,
    input wire rst,
    input wire actual_outcome, // 1 for taken, 0 for not taken
    output reg predicted_outcome // 1 for taken, 0 for not taken
);
    reg [1:0] state; // 2-bit state for the predictor

    // State encoding
    parameter ST_NOT_TAKEN_STRONG = 2'b00;
    parameter ST_NOT_TAKEN_WEAK  = 2'b01;
    parameter ST_TAKEN_WEAK      = 2'b10;
    parameter ST_TAKEN_STRONG    = 2'b11;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= ST_NOT_TAKEN_STRONG; // Initialize state
            predicted_outcome <= 0;
        end else begin
            predicted_outcome <= (state[1]); // Output prediction based on state
            case (state)
                ST_NOT_TAKEN_STRONG: if (actual_outcome) state <= ST_NOT_TAKEN_WEAK;
                ST_NOT_TAKEN_WEAK:   if (actual_outcome) state <= ST_TAKEN_STRONG; else state <= ST_NOT_TAKEN_STRONG;
                ST_TAKEN_WEAK:       if (~actual_outcome) state <= ST_NOT_TAKEN_STRONG; else state <= ST_TAKEN_STRONG;
                ST_TAKEN_STRONG:     if (~actual_outcome) state <= ST_TAKEN_WEAK;
            endcase
        end
    end
endmodule