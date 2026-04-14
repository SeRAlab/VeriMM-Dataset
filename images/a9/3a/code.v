module top_module(
    input pipelineReady,
    input scheduleTask,
    input [2:0] workCounter,
    input scryptResultInputAvailable,
    input doWork,
    output reg [7:0] preparing,
    output reg decreasePrepare,
    output reg scryptResultAvailable
);always @(*) begin
    // increment preparing counter
    if (pipelineReady && scheduleTask && workCounter == 3 && !decreasePrepare && !doWork) begin
        preparing <= preparing + 1;
    end
    
    // decrement preparing counter
    if (!pipelineReady && !scheduleTask && decreasePrepare && !doWork) begin
        preparing <= preparing - 1;
    end
    
    // set decreasePrepare signal
    if (!scryptResultInputAvailable) begin
        decreasePrepare <= 1;
    end else begin
        decreasePrepare <= 0;
    end
    
    // set scryptResultAvailable signal
    scryptResultAvailable <= preparing > 0;
end

endmodule