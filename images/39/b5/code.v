module pipeline_processor (
    input clk,
    input rst,
    input stall_signal,
    input flush_signal,
    input [7:0] instruction_in,
    output reg [7:0] IF_stage,
    output reg [7:0] ID_stage,
    output reg [7:0] EX_stage,
    output reg [7:0] MEM_stage,
    output reg [7:0] WB_stage
);

reg [7:0] pipeline [0:6]; // 7 stages

always @(posedge clk or posedge rst) begin
    if (rst) begin
        IF_stage <= 8'b0;
        ID_stage <= 8'b0;
        EX_stage <= 8'b0;
        MEM_stage <= 8'b0;
        WB_stage <= 8'b0;
        pipeline[0] <= 8'b0;
        pipeline[1] <= 8'b0;
        pipeline[2] <= 8'b0;
        pipeline[3] <= 8'b0;
        pipeline[4] <= 8'b0;
        pipeline[5] <= 8'b0;
        pipeline[6] <= 8'b0;
    end else begin
        if (flush_signal) begin
            IF_stage <= 8'b0;
            ID_stage <= 8'b0;
            EX_stage <= 8'b0;
            MEM_stage <= 8'b0;
            WB_stage <= 8'b0;
        end else begin
            IF_stage <= instruction_in; // Fetch new instruction
            if (!stall_signal) begin
                pipeline[0] <= IF_stage;  // IF stage
                pipeline[1] <= pipeline[0]; // ID stage
                pipeline[2] <= pipeline[1]; // EX stage
                pipeline[3] <= pipeline[2]; // MEM stage
                pipeline[4] <= pipeline[3]; // WB stage
            end
            // Output current stage values
            ID_stage <= pipeline[0];
            EX_stage <= pipeline[1];
            MEM_stage <= pipeline[2];
            WB_stage <= pipeline[3];
        end
    end
end
endmodule