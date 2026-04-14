module instruction_pipeline (
    input clk,
    input reset,
    input [4:0] instruction,
    output reg [2:0] stage
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            stage <= 3'b000; // Reset to Fetch stage
        end else begin
            case (stage)
                3'b000: stage <= 3'b001; // Move to Decode stage
                3'b001: stage <= 3'b010; // Move to Execute stage
                3'b010: stage <= 3'b000; // Move back to Fetch stage
                default: stage <= 3'b000; // Default to Fetch stage
            endcase
        end
    end

endmodule