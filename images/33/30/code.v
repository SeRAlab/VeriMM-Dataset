module branch_predictor (
    input clk,
    input reset,
    input taken,
    output reg [1:0] prediction
);
    // State encoding: 00 -> strongly not taken, 01 -> weakly not taken,
    // 10 -> weakly taken, 11 -> strongly taken
    reg [1:0] state;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 2'b00; // reset to strongly not taken
        end else begin
            prediction <= state; // output current prediction
            case (state)
                2'b00: if (taken) state <= 2'b01; // move to weakly not taken
                2'b01: if (taken) state <= 2'b10; // move to weakly taken
                2'b10: if (taken) state <= 2'b11; // move to strongly taken
                        else state <= 2'b01; // move to weakly not taken
                2'b11: if (~taken) state <= 2'b10; // move to weakly taken
            endcase
        end
    end
endmodule