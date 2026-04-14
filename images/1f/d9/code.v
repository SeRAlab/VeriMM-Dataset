module instruction_pipeline (
    input wire clk,
    input wire reset,
    input wire [15:0] instruction_in,
    input wire [15:0] address_in,
    input wire [15:0] data_in,
    output reg [15:0] instruction_out,
    output reg [15:0] address_out,
    output reg [15:0] data_out
);
    reg [15:0] IF_ID_instruction;
    reg [15:0] IF_ID_address;
    reg [15:0] ID_EX_data;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            IF_ID_instruction <= 16'b0;
            IF_ID_address <= 16'b0;
            ID_EX_data <= 16'b0;
            instruction_out <= 16'b0;
            address_out <= 16'b0;
            data_out <= 16'b0;
        end else begin
            // Stage 1: Instruction Fetch to Instruction Decode
            IF_ID_instruction <= instruction_in;
            IF_ID_address <= address_in;

            // Stage 2: Instruction Decode to Execute
            ID_EX_data <= data_in;

            // Stage 3: Execute to Memory
            instruction_out <= IF_ID_instruction;
            address_out <= IF_ID_address;
            data_out <= ID_EX_data;
        end
    end
endmodule