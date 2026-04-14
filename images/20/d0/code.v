module pcie_packet_receiver (
    input wire clk,
    input wire rst_n,
    input wire [15:0] packet_in,
    input wire packet_valid,
    output reg valid_packet
);

    reg [3:0] state;
    localparam IDLE = 4'b0000, CHECK_HEADER = 4'b0001, VALIDATE = 4'b0010, DONE = 4'b0011;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            valid_packet <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (packet_valid) begin
                        state <= CHECK_HEADER;
                    end
                end
                CHECK_HEADER: begin
                    if (packet_in[15:12] == 4'b1010) begin
                        state <= VALIDATE;
                    end else begin
                        valid_packet <= 1'b0;
                        state <= DONE;
                    end
                end
                VALIDATE: begin
                    // Assuming valid length is 16 bits for simplicity
                    // Actual length validation logic can be added here
                    valid_packet <= 1'b1;
                    state <= DONE;
                end
                DONE: begin
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule