module branch_predictor (
    input clk,
    input rst,
    input taken, // 1 for Taken, 0 for Not Taken
    output reg prediction // 1 for Taken, 0 for Not Taken
);
    reg [1:0] state;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= 2'b00; // Initial state
        end else begin
            case (state)
                2'b00: state <= taken ? 2'b10 : 2'b00; // Strongly Not Taken
                2'b01: state <= taken ? 2'b10 : 2'b00; // Weakly Not Taken
                2'b10: state <= taken ? 2'b11 : 2'b01; // Weakly Taken
                2'b11: state <= taken ? 2'b11 : 2'b10; // Strongly Taken
            endcase
        end
    end

    always @(*) begin
        prediction = (state[1] == 1); // Taken if state is 10 or 11
    end
endmodule