module branch_predictor(
    input clk,
    input reset,
    input taken, // 1 if taken, 0 if not taken
    output reg [1:0] counter // 2-bit saturating counter
);
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 2'b00; // Initialize to Strongly Not Taken
        end else begin
            case (counter)
                2'b00: counter <= (taken) ? 2'b01 : 2'b00; // Strongly Not Taken
                2'b01: counter <= (taken) ? 2'b10 : 2'b00; // Weakly Not Taken
                2'b10: counter <= (taken) ? 2'b11 : 2'b01; // Weakly Taken
                2'b11: counter <= (taken) ? 2'b11 : 2'b10; // Strongly Taken
            endcase
        end
    end
endmodule