module ARQ_System (
    input wire clk,
    input wire reset,
    input wire [4:0] data_in,
    input wire ack,
    output reg [4:0] data_out,
    output reg retransmit
);

    reg [4:0] stored_data;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            stored_data <= 5'b00000;
            data_out <= 5'b00000;
            retransmit <= 1'b0;
        end else begin
            if (ack) begin
                stored_data <= data_in;
                data_out <= data_in;
                retransmit <= 1'b0;
            end else begin
                retransmit <= 1'b1; // Request retransmission
                data_out <= stored_data; // Keep previous data
            end
        end
    end
endmodule