module instruction_pipeline (
    input clk,
    input reset,
    input [4:0] instruction_in,
    output reg [4:0] instruction_out
);
    reg [4:0] fetch_stage;
    reg [4:0] decode_stage;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            fetch_stage <= 5'b00000;
            decode_stage <= 5'b00000;
            instruction_out <= 5'b00000;
        end else begin
            fetch_stage <= instruction_in; // Fetch
            decode_stage <= fetch_stage;    // Decode
            instruction_out <= decode_stage; // Execute
        end
    end
endmodule