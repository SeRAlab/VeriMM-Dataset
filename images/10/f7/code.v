module instruction_pipeline (
    input clk,
    input reset,
    input [15:0] instruction_in,
    output reg [15:0] instruction_out,
    output reg [15:0] data_out
);
    reg [15:0] IF_ID, ID_EX, EX_MEM, MEM_WB;
    reg hazard_detected;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            IF_ID <= 0;
            ID_EX <= 0;
            EX_MEM <= 0;
            MEM_WB <= 0;
            instruction_out <= 0;
            data_out <= 0;
            hazard_detected <= 0;
        end else begin
            // Pipeline stages
            IF_ID <= instruction_in; // Instruction Fetch
            ID_EX <= IF_ID;          // Instruction Decode
            EX_MEM <= ID_EX;         // Execute
            MEM_WB <= EX_MEM;        // Memory Access

            // Hazard detection (simplified for this example)
            if (ID_EX[15:12] == EX_MEM[15:12]) begin
                hazard_detected <= 1; // Example of hazard condition
            end else begin
                hazard_detected <= 0;
            end

            // Output results
            if (!hazard_detected) begin
                instruction_out <= MEM_WB;
                data_out <= MEM_WB; // Example data output
            end else begin
                instruction_out <= 0; // Stall
                data_out <= 0;
            end
        end
    end
endmodule