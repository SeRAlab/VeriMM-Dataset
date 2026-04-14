module dma_controller (
    input wire clk,
    input wire reset,
    input wire start,
    input wire [2:0] channel,
    input wire [7:0] data_in,
    input wire ack,
    output reg [7:0] data_out,
    output reg busy
);

    // Internal state
    reg transferring;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            data_out <= 8'b0;
            busy <= 1'b0;
            transferring <= 1'b0;
        end else begin
            if (start && !busy) begin
                busy <= 1'b1;
                transferring <= 1'b1;
            end
            
            if (transferring && ack) begin
                data_out <= data_in;
                busy <= 1'b0;
                transferring <= 1'b0;
            end
        end
    end
endmodule