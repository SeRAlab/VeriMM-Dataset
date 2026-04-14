module branch_predictor (
    input wire clk,
    input wire reset,
    input wire branch_outcome, // 1 for taken, 0 for not taken
    output reg prediction // 1 for taken, 0 for not taken
);
    reg [1:0] counter; // 2-bit saturating counter

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 2'b00; // reset counter
            prediction <= 1'b0; // initial prediction
        end else begin
            // Update the saturating counter
            case (counter)
                2'b00: begin
                    if (branch_outcome)
                        counter <= 2'b01;
                end
                2'b01: begin
                    if (branch_outcome)
                        counter <= 2'b10;
                    else
                        counter <= 2'b00;
                end
                2'b10: begin
                    if (branch_outcome)
                        counter <= 2'b11;
                    else
                        counter <= 2'b01;
                end
                2'b11: begin
                    if (!branch_outcome)
                        counter <= 2'b10;
                end
            endcase
            // Set the prediction based on counter
            prediction <= (counter[1] == 1'b1); // Predict taken if MSB is 1
        end
    end
endmodule