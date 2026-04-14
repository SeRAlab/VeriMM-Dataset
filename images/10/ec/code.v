module pipeline(
    input wire clk,
    input wire reset,
    input wire [31:0] instruction_in,
    output reg [31:0] instruction_out
);
    reg [31:0] IF_stage, ID_stage, EX_stage, MEM_stage;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            IF_stage <= 32'b0;
            ID_stage <= 32'b0;
            EX_stage <= 32'b0;
            MEM_stage <= 32'b0;
            instruction_out <= 32'b0;
        end else begin
            IF_stage <= instruction_in; // Fetch instruction
            ID_stage <= IF_stage;        // Decode instruction
            EX_stage <= ID_stage;        // Execute instruction
            MEM_stage <= EX_stage;       // Access memory
            instruction_out <= MEM_stage; // Write back stage
        end
    end
endmodule