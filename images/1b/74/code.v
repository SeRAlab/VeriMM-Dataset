module ARQ_System(
    input wire clk,
    input wire reset,
    input wire ack,
    input wire [7:0] data_in,
    output reg [7:0] data_out
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        data_out <= 8'b0; // Clear stored data on reset
    end else if (ack) begin
        data_out <= data_in; // Latch new data if ACK is received
    end
    // If ACK is not received, retain the previous data_out
end

endmodule