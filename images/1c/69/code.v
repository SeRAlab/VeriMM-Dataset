module branch_predictor (
    input clk,
    input reset,
    input branch_outcome,  // 1 for taken, 0 for not taken
    output reg prediction   // 1 for taken, 0 for not taken
);
    reg [1:0] history; // 2-bit history register

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            history <= 2'b00; // reset history
            prediction <= 0;  // reset prediction
        end else begin
            prediction <= (history[1] == 1) ? 1 : 0; // prediction logic
            // Update history based on the current outcome
            history <= {history[0], branch_outcome};  
        end
    end
endmodule