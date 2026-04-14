module top_module(
    input clk,      // Added missing clock input
    input in,
    output out
);parameter s0 = 3'b000, s1 = 3'b001, s2 = 3'b010, s3 = 3'b011, s4 = 3'b100, s5 = 3'b101;
    reg [2:0] currentState, nextState;

    always @ (currentState or in) begin
        case (currentState)
            s0: if (in == 1'b0) nextState = s1; else nextState = s5;
            s1: if (in == 1'b0) nextState = s2; else nextState = s5;
            s2: if (in == 1'b0) nextState = s3; else nextState = s5;
            s3: if (in == 1'b0) nextState = s4; else nextState = s5;
            s4: if (in == 1'b0) nextState = s5; else nextState = s5;
            s5: nextState = s5;
        endcase
    end

    always @ (posedge clk) begin
        currentState <= nextState;
    end

    assign out = (currentState == s5);

endmodule