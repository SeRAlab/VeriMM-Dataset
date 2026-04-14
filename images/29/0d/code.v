module branch_predictor(
    input clk,
    input rst,
    input taken, // 1 if the branch is taken, 0 otherwise
    output reg prediction // 1 if predicted taken, 0 otherwise
);
    reg [1:0] counter; // 2-bit counter

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 2'b00; // Initial state (Strongly Nottaken)
            prediction <= 0; // Initial prediction (not taken)
        end else begin
            prediction <= counter[1]; // Most significant bit indicates prediction
            // Update the counter based on taken input
            case (counter)
                2'b00: if (taken) counter <= 2'b01; // from Strongly Nottaken to Weakly Nottaken
                2'b01: if (taken) counter <= 2'b10; // from Weakly Nottaken to Weakly Taken
                        else counter <= 2'b00; // from Weakly Nottaken to Strongly Nottaken
                2'b10: if (taken) counter <= 2'b11; // from Weakly Taken to Strongly Taken
                        else counter <= 2'b01; // from Weakly Taken to Weakly Nottaken
                2'b11: if (taken) counter <= 2'b11; // stays Strongly Taken
                        else counter <= 2'b10; // from Strongly Taken to Weakly Taken
            endcase
        end
    end
endmodule