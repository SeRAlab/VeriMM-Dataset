module rrt_fsm(
    input wire clk,
    input wire reset,
    input wire start,
    input wire node_generated, // Signal indicating a new node has been generated
    input wire done, // Signal indicating the process is completed
    output reg [1:0] state // 2-bit state output (00: IDLE, 01: EXPLORE, 10: CONNECT)
);

    // State encoding
    localparam IDLE = 2'b00;
    localparam EXPLORE = 2'b01;
    localparam CONNECT = 2'b10;

    // State transition
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: if (start) state <= EXPLORE;
                EXPLORE: if (node_generated) state <= CONNECT;
                CONNECT: if (done) state <= IDLE;
                default: state <= IDLE;
            endcase
        end
    end
endmodule