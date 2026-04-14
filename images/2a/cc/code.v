module branch_predictor (
    input wire [3:0] branch_addr,
    input wire branch_outcome, // 1 for taken, 0 for not taken
    input wire clk,
    output reg prediction // 1 for taken, 0 for not taken
);
    reg [1:0] state;

    always @(posedge clk) begin
        case (state)
            2'b00: begin // strongly not taken
                prediction <= 0;
                if (branch_outcome) state <= 2'b01; // weakly not taken
            end
            2'b01: begin // weakly not taken
                prediction <= 0;
                if (branch_outcome) state <= 2'b10; // weakly taken
                else state <= 2'b00; // stay
            end
            2'b10: begin // weakly taken
                prediction <= 1;
                if (branch_outcome) state <= 2'b11; // strongly taken
                else state <= 2'b01; // weakly not taken
            end
            2'b11: begin // strongly taken
                prediction <= 1;
                if (!branch_outcome) state <= 2'b10; // weakly taken
            end
        endcase
    end

    // Initial state
    initial begin
        state = 2'b00; // start with strongly not taken
        prediction = 0;
    end
endmodule