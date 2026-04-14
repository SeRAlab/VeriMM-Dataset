module pipelined_processor (
    input clk,
    input [4:0] instruction,
    output reg [4:0] result
);
    reg [4:0] stage [0:6]; // Array for 7 stages
    integer i;

    always @(posedge clk) begin
        // Shift stages
        stage[6] <= stage[5];
        for (i = 5; i > 0; i = i - 1) begin
            stage[i-1] <= stage[i];
        end
        stage[0] <= instruction; // New instruction at stage 0

        // Process the instruction in the last stage
        if (stage[6][4:3] == 2'b00) begin // Add operation
            result <= stage[6][2:0] + stage[6][2:0]; // Assuming we add the same value
        end else begin
            result <= stage[6]; // Pass through for nop
        end
    end
endmodule