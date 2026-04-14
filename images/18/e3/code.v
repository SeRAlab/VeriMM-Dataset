module branch_predictor(
    input wire clk,
    input wire rst,
    input wire branch_outcome, // 1 for taken, 0 for not taken
    output reg prediction // 1 for taken, 0 for not taken
);
    reg [1:0] counter; // 2-bit saturating counter

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 2'b00; // Initialize to 0
            prediction <= 0; // Initialize prediction to not taken
        end else begin
            prediction <= (counter[1]); // Predict based on MSB of counter
            if (branch_outcome) begin
                if (counter < 2'b11) 
                    counter <= counter + 1; // Increment counter for taken
            end else begin
                if (counter > 2'b00) 
                    counter <= counter - 1; // Decrement counter for not taken
            end
        end
    end
endmodule