module branch_predictor(
    input clk,
    input rst,
    input [1:0] branch_addr, // 2-bit address for 4 entries
    input taken,             // Actual outcome of the branch (1 for taken, 0 for not taken)
    output reg prediction     // Prediction output (1 for taken, 0 for not taken)
);

    reg [1:0] predictor_table [3:0]; // 2-bit saturating counter for each entry

    initial begin
        // Initialize predictor table to weakly not taken
        predictor_table[0] = 2'b01;
        predictor_table[1] = 2'b01;
        predictor_table[2] = 2'b01;
        predictor_table[3] = 2'b01;
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset predictor table
            predictor_table[0] <= 2'b01;
            predictor_table[1] <= 2'b01;
            predictor_table[2] <= 2'b01;
            predictor_table[3] <= 2'b01;
        end else begin
            // Prediction based on the table
            prediction <= predictor_table[branch_addr][1]; // Most significant bit indicates prediction

            // Update the predictor table based on actual outcome
            if (taken) begin
                if (predictor_table[branch_addr] < 2'b11)
                    predictor_table[branch_addr] <= predictor_table[branch_addr] + 1; // Increment
            end else begin
                if (predictor_table[branch_addr] > 2'b00)
                    predictor_table[branch_addr] <= predictor_table[branch_addr] - 1; // Decrement
            end
        end
    end
endmodule