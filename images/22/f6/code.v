module branch_predictor(
    input clk,
    input reset,
    input taken, // input signal indicating if the branch was taken (1) or not taken (0)
    output reg [1:0] prediction // output the current prediction state
);
    // State encoding
    parameter STRONGLY_NOT_TAKEN = 2'b00;
    parameter WEAKLY_NOT_TAKEN = 2'b01;
    parameter WEAKLY_TAKEN = 2'b10;
    parameter STRONGLY_TAKEN = 2'b11;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            prediction <= STRONGLY_NOT_TAKEN; // reset to strongly not taken
        end else begin
            case (prediction)
                STRONGLY_NOT_TAKEN: 
                    if (taken) prediction <= WEAKLY_NOT_TAKEN;
                WEAKLY_NOT_TAKEN: 
                    if (taken) prediction <= WEAKLY_TAKEN;
                    else prediction <= STRONGLY_NOT_TAKEN;
                WEAKLY_TAKEN: 
                    if (taken) prediction <= STRONGLY_TAKEN;
                    else prediction <= WEAKLY_NOT_TAKEN;
                STRONGLY_TAKEN: 
                    if (!taken) prediction <= WEAKLY_TAKEN;
            endcase
        end
    end
endmodule