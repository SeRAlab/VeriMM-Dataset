module dma_controller (
    input clk,
    input reset,
    input req0,          // Request signal for channel 0
    input req1,          // Request signal for channel 1
    output reg transfer0, // Transfer signal for channel 0
    output reg transfer1  // Transfer signal for channel 1
);
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            transfer0 <= 0;
            transfer1 <= 0;
        end else begin
            transfer0 <= req0; // Transfer if req0 is asserted
            transfer1 <= req1; // Transfer if req1 is asserted
        end
    end

endmodule