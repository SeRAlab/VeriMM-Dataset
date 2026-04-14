module instruction_pipeline (
    input clk,
    input reset,
    input [4:0] instruction_in,
    output reg [4:0] instruction_out
);
    reg [4:0] if_id, id_ex;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            if_id <= 5'b0;
            id_ex <= 5'b0;
            instruction_out <= 5'b0;
        end else begin
            // Fetch Stage
            if_id <= instruction_in; // Instruction fetched
            
            // Decode Stage
            id_ex <= if_id; // Instruction decoded
            
            // Execute Stage
            instruction_out <= id_ex; // Instruction executed
        end
    end
endmodule