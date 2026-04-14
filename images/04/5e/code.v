module dma_controller (
    input wire clk,
    input wire reset,
    input wire request_a,
    input wire request_b,
    output reg ack_a,
    output reg ack_b,
    input wire [7:0] data_a,
    input wire [7:0] data_b,
    output reg [7:0] mem_data
);
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            ack_a <= 0;
            ack_b <= 0;
            mem_data <= 8'b0;
        end else begin
            if (request_a) begin
                ack_a <= 1;
                mem_data <= data_a;
            end else begin
                ack_a <= 0;
            end

            if (request_b && !request_a) begin
                ack_b <= 1;
                mem_data <= data_b;
            end else begin
                ack_b <= 0;
            end
        end
    end
endmodule