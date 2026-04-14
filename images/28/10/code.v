module sata_controller(
    input wire clk,
    input wire reset,
    input wire start,
    output reg [1:0] state
);
    // State encoding
    localparam IDLE = 2'b00;
    localparam SEND_DATA = 2'b01;
    localparam RECEIVE_DATA = 2'b10;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        state <= SEND_DATA;
                    end
                end
                SEND_DATA: begin
                    state <= RECEIVE_DATA;
                end
                RECEIVE_DATA: begin
                    state <= IDLE;
                end
                default: state <= IDLE;
            endcase
        end
    end
endmodule