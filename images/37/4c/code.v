module branch_predictor(
    input clk,
    input rst,
    input [1:0] address,
    input branch_taken,
    output reg prediction
);
    reg [1:0] state [0:3]; // 4 entries for 2-bit states
    integer i;

    initial begin
        for (i = 0; i < 4; i = i + 1) begin
            state[i] = 2'b00; // Initialize all states to 00
        end
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for (i = 0; i < 4; i = i + 1) begin
                state[i] <= 2'b00; // Reset all states to 00
            end
        end else begin
            prediction <= (state[address] == 2'b10 || state[address] == 2'b11); // Predict Taken
            // Update state based on branch outcome
            case (state[address])
                2'b00: if (branch_taken) state[address] <= 2'b01; else state[address] <= 2'b00;
                2'b01: if (branch_taken) state[address] <= 2'b10; else state[address] <= 2'b00;
                2'b10: if (branch_taken) state[address] <= 2'b11; else state[address] <= 2'b01;
                2'b11: if (branch_taken) state[address] <= 2'b11; else state[address] <= 2'b10;
            endcase
        end
    end
endmodule