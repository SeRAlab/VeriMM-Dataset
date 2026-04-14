module sata_controller(
    input wire clk,
    input wire [1:0] ctrl_signal,
    output reg [1:0] state
);

    // State definitions
    localparam IDLE = 2'b00;
    localparam TRANSMIT = 2'b01;
    localparam RECEIVE = 2'b10;

    always @(posedge clk) begin
        case (ctrl_signal)
            2'b00: state <= IDLE;
            2'b01: state <= TRANSMIT;
            2'b10: state <= RECEIVE;
            default: state <= IDLE; // Default to IDLE on invalid input
        endcase
    end
endmodule