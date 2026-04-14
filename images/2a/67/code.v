module pcie_request_handler (
    input wire clk,
    input wire rst,
    input wire request,
    input wire [7:0] data_in,
    output reg ack,
    output reg [7:0] data_out
);
    reg state;  // 0 = idle, 1 = processing

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            ack <= 0;
            data_out <= 0;
            state <= 0;
        end else begin
            case (state)
                0: begin // Idle state
                    ack <= 0;
                    if (request) begin
                        data_out <= data_in;
                        ack <= 1;
                        state <= 1; // Move to processing state
                    end
                end
                1: begin // Processing state
                    if (ack) begin
                        ack <= 0; // Acknowledge the request
                        state <= 0; // Go back to idle
                    end
                end
            endcase
        end
    end
endmodule