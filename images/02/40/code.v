module dma_controller (
    input wire req1,
    input wire req2,
    input wire clk,
    input wire reset,
    output reg ack1,
    output reg ack2
);
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            ack1 <= 0;
            ack2 <= 0;
        end else begin
            if (req1) begin
                ack1 <= 1;
                ack2 <= 0; // Prioritize req1
            end else if (req2) begin
                ack1 <= 0;
                ack2 <= 1;
            end else begin
                ack1 <= 0;
                ack2 <= 0;
            end
        end
    end
endmodule