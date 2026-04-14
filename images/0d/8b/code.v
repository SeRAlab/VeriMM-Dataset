module branch_predictor (
    input wire clk,
    input wire reset,
    input wire branch_outcome,
    output reg prediction
);
    reg [1:0] counter;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 2'b00; // Initialize counter to 00
            prediction <= 0;  // Initial prediction not taken
        end else begin
            prediction <= counter[1]; // Output prediction based on MSB of counter
            case (counter)
                2'b00: if (branch_outcome) counter <= 2'b01; // Update from strongly not taken
                2'b01: if (branch_outcome) counter <= 2'b10; // Update from weakly not taken
                2'b10: if (branch_outcome) counter <= 2'b11; // Update from weakly taken
                        else counter <= 2'b01; // Update to weakly not taken
                2'b11: if (~branch_outcome) counter <= 2'b10; // Update from strongly taken
            endcase
        end
    end
endmodule