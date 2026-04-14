module pcie_packet_processor (
    input wire clk,
    input wire reset,
    input wire valid_in,
    input wire [31:0] request_data,
    output reg valid_out,
    output reg [31:0] response_data
);
    reg [1:0] state;
    localparam IDLE = 2'b00, WAIT = 2'b01, RESP = 2'b10;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            valid_out <= 0;
            response_data <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (valid_in) begin
                        state <= WAIT;
                    end
                end
                WAIT: begin
                    state <= RESP;
                end
                RESP: begin
                    valid_out <= 1;
                    response_data <= request_data + 1;
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule